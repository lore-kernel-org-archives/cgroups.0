From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [BUG] cgroup writeback list corruption
Date: Wed, 16 Mar 2016 18:13:50 -0700
Message-ID: <20160317011350.GN21104@mtj.duckdns.org>
References: <CAAeU0aMYeM_39Y2+PaRvyB1nqAPYZSNngJ1eBRmrxn7gKAt2Mg@mail.gmail.com>
 <20160316221015.GL21104@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2zjWzr4wN+j1RXHeDx51KbYiKoMkNYlPWh2Cqi++t0s=;
        b=inETTDahvJM6GUgVQoDGXK1jsztCCi6X+PeXQw+Svowjscu0BsLlZEVhMbOmhVD+bf
         1IZyQKxPbtokTXU/b2Dymax/v06xkJoFG9QSXwMVBPso0dyYNalpPWCtrXMaZ3v6v5gE
         KOwTAiYeF76asf07WphLsg07pr+AxP+uCuX07SPIgvnEG/mVfItEvuGgVIIYWRjJ3JjZ
         p7FnMbPU1iCSHxWKwFHLkbNnx2D2+t1BZZIbXRBtanMJ8eISh7sfi0yNYCwWqrF0GCNw
         +y0FMTsEc4q7v2ptb6pmvQATbR/Cpntz9Vt+n65IAfnVemt8bA1Q1eqZ6NZ//u2ro6ya
         dctA==
Content-Disposition: inline
In-Reply-To: <20160316221015.GL21104-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tahsin Erdogan <tahsin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hello, Tahsin.

FYI, this is the preliminary patch I'm trying to test.  I'm running
the repro case w/o the patch but the bug hasn't triggered yet.

Thanks.

Index: work/include/linux/backing-dev.h
===================================================================
--- work.orig/include/linux/backing-dev.h
+++ work/include/linux/backing-dev.h
@@ -362,6 +362,26 @@ static inline struct bdi_writeback *inod
 	return inode->i_wb;
 }
 
+static inline struct bdi_writeback *
+unlocked_inode_to_wb_lock_list(struct inode *inode)
+{
+	struct bdi_writeback *wb;
+
+	rcu_read_lock();
+
+	while (true) {
+		wb = inode->i_wb;
+		spin_lock(&wb->list_lock);
+		if (likely(wb == inode->i_wb))
+			break;
+		spin_unlock(&wb->list_lock);
+		cpu_relax();
+	}
+
+	rcu_read_unlock();
+	return wb;
+}
+
 /**
  * unlocked_inode_to_wb_begin - begin unlocked inode wb access transaction
  * @inode: target inode
@@ -374,8 +394,7 @@ static inline struct bdi_writeback *inod
  * unlocked_inode_to_wb_end().
  *
  * The caller must call unlocked_inode_to_wb_end() with *@lockdep
- * afterwards and can't sleep during transaction.  IRQ may or may not be
- * disabled on return.
+ * afterwards and can't sleep during transaction.
  */
 static inline struct bdi_writeback *
 unlocked_inode_to_wb_begin(struct inode *inode, bool *lockedp)
@@ -388,14 +407,16 @@ unlocked_inode_to_wb_begin(struct inode
 	 */
 	*lockedp = smp_load_acquire(&inode->i_state) & I_WB_SWITCH;
 
-	if (unlikely(*lockedp))
-		spin_lock_irq(&inode->i_mapping->tree_lock);
-
 	/*
-	 * Protected by either !I_WB_SWITCH + rcu_read_lock() or tree_lock.
+	 * Protected by either !I_WB_SWITCH + rcu_read_lock(),
 	 * inode_to_wb() will bark.  Deref directly.
 	 */
-	return inode->i_wb;
+	if (likely(!*lockedp))
+		return inode->i_wb;
+
+	rcu_read_unlock();
+
+	return unlocked_inode_to_wb_lock_list(inode);
 }
 
 /**
@@ -405,10 +426,10 @@ unlocked_inode_to_wb_begin(struct inode
  */
 static inline void unlocked_inode_to_wb_end(struct inode *inode, bool locked)
 {
-	if (unlikely(locked))
-		spin_unlock_irq(&inode->i_mapping->tree_lock);
-
-	rcu_read_unlock();
+	if (likely(!locked))
+		rcu_read_unlock();
+	else
+		spin_unlock(&inode->i_wb->list_lock);
 }
 
 #else	/* CONFIG_CGROUP_WRITEBACK */
@@ -453,6 +474,15 @@ static inline struct bdi_writeback *inod
 }
 
 static inline struct bdi_writeback *
+unlocked_inode_to_wb_lock_list(struct inode *inode)
+{
+	struct bdi_writeback *wb = inode_to_wb(inode);
+
+	spin_lock(&wb->list_lock);
+	return wb;
+}
+
+static inline struct bdi_writeback *
 unlocked_inode_to_wb_begin(struct inode *inode, bool *lockedp)
 {
 	return inode_to_wb(inode);
Index: work/fs/fs-writeback.c
===================================================================
--- work.orig/fs/fs-writeback.c
+++ work/fs/fs-writeback.c
@@ -1309,10 +1309,10 @@ __writeback_single_inode(struct inode *i
  * we go e.g. from filesystem. Flusher thread uses __writeback_single_inode()
  * and does more profound writeback list handling in writeback_sb_inodes().
  */
-static int
-writeback_single_inode(struct inode *inode, struct bdi_writeback *wb,
-		       struct writeback_control *wbc)
+static int writeback_single_inode(struct inode *inode,
+				  struct writeback_control *wbc)
 {
+	struct bdi_writeback *wb;
 	int ret = 0;
 
 	spin_lock(&inode->i_lock);
@@ -1350,7 +1350,8 @@ writeback_single_inode(struct inode *ino
 	ret = __writeback_single_inode(inode, wbc);
 
 	wbc_detach_inode(wbc);
-	spin_lock(&wb->list_lock);
+
+	wb = unlocked_inode_to_wb_lock_list(inode);
 	spin_lock(&inode->i_lock);
 	/*
 	 * If inode is clean, remove it from writeback lists. Otherwise don't
@@ -1515,8 +1516,7 @@ static long writeback_sb_inodes(struct s
 			cond_resched();
 		}
 
-
-		spin_lock(&wb->list_lock);
+		wb = unlocked_inode_to_wb_lock_list(inode);
 		spin_lock(&inode->i_lock);
 		if (!(inode->i_state & I_DIRTY_ALL))
 			wrote++;
@@ -2310,7 +2310,6 @@ EXPORT_SYMBOL(sync_inodes_sb);
  */
 int write_inode_now(struct inode *inode, int sync)
 {
-	struct bdi_writeback *wb = &inode_to_bdi(inode)->wb;
 	struct writeback_control wbc = {
 		.nr_to_write = LONG_MAX,
 		.sync_mode = sync ? WB_SYNC_ALL : WB_SYNC_NONE,
@@ -2322,7 +2321,7 @@ int write_inode_now(struct inode *inode,
 		wbc.nr_to_write = 0;
 
 	might_sleep();
-	return writeback_single_inode(inode, wb, &wbc);
+	return writeback_single_inode(inode, &wbc);
 }
 EXPORT_SYMBOL(write_inode_now);
 
@@ -2339,7 +2338,7 @@ EXPORT_SYMBOL(write_inode_now);
  */
 int sync_inode(struct inode *inode, struct writeback_control *wbc)
 {
-	return writeback_single_inode(inode, &inode_to_bdi(inode)->wb, wbc);
+	return writeback_single_inode(inode, wbc);
 }
 EXPORT_SYMBOL(sync_inode);
 
