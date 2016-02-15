From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [BUG] cgroup writeback crash
Date: Mon, 15 Feb 2016 16:00:47 -0500
Message-ID: <20160215210047.GN3965@htj.duckdns.org>
References: <CAAeU0aNCq7LGODvVGRU-oU_o-6enii5ey0p1c26D1ZzYwkDc5A@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=9ynvIgxl6mwrRspje8Ep+kF3ojg9HgM0Hf3LRP2nBcc=;
        b=CqUYq+saRBfruZpkOk6H8I960z9lHTER5Sn+mag5Djez4aquYC9s+NXGBTAGEH48/M
         PpCrVfX14kumEo00urdhxQGuRa8Ph7YsdGItXA5+gLHCALcALN3K6dKuqILcNcQ10TjD
         oq4glyaGq8RXUpQXqJsM3fgskdBQeZnq68uDCBrMjbgDFCkMF/aTShzLIMeUSWbu42T/
         B8y5Hi8r6JP5H9ZRNiud1GGvopSntYfosY3hQ1tRPWJdZ7kqzZFtGxOnMHwj4P1y3lOw
         M9f2cnAFQTdL96a69c+Tv2YYhrrA90mh59jmx3KCeGEkwSfE8Ka/UKvIxp5oR2rvF7Ww
         FeZg==
Content-Disposition: inline
In-Reply-To: <CAAeU0aNCq7LGODvVGRU-oU_o-6enii5ey0p1c26D1ZzYwkDc5A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tahsin Erdogan <tahsin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Nauman Rafique <nauman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hello,

On Fri, Feb 12, 2016 at 11:32:22AM -0800, Tahsin Erdogan wrote:
> cgroup based writeback has a race condition bug leads to a kernel crash.
> 
> When an inode's bdi_writeback is switched, an additional ref count on the inode
> is acquired in inode_switch_wbs()  and the actual reassignment work is scheduled
> to be executed later. If file gets deleted and fs unmounted before the work is
> finished, then the last ref drop by inode_switch_wbs_work_fn() will
> try to evict the
> inode and so attempt to access released filesystem data.
> 
> Here is the shell script that I am using to reproduce this (not a
> reliable repro):

Can you please test whether the following patch fixes the issue?

Thanks.

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 6915c95..1f76d89 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -317,6 +317,7 @@ static void inode_switch_wbs_work_fn(struct work_struct *work)
 	struct inode_switch_wbs_context *isw =
 		container_of(work, struct inode_switch_wbs_context, work);
 	struct inode *inode = isw->inode;
+	struct super_block *sb = inode->i_sb;
 	struct address_space *mapping = inode->i_mapping;
 	struct bdi_writeback *old_wb = inode->i_wb;
 	struct bdi_writeback *new_wb = isw->new_wb;
@@ -423,6 +424,7 @@ static void inode_switch_wbs_work_fn(struct work_struct *work)
 	wb_put(new_wb);
 
 	iput(inode);
+	deactivate_super(sb);
 	kfree(isw);
 }
 
@@ -469,11 +471,14 @@ static void inode_switch_wbs(struct inode *inode, int new_wb_id)
 
 	/* while holding I_WB_SWITCH, no one else can update the association */
 	spin_lock(&inode->i_lock);
+
 	if (inode->i_state & (I_WB_SWITCH | I_FREEING) ||
-	    inode_to_wb(inode) == isw->new_wb) {
-		spin_unlock(&inode->i_lock);
-		goto out_free;
-	}
+	    inode_to_wb(inode) == isw->new_wb)
+		goto out_unlock;
+
+	if (!atomic_inc_not_zero(&inode->i_sb->s_active))
+		goto out_unlock;
+
 	inode->i_state |= I_WB_SWITCH;
 	spin_unlock(&inode->i_lock);
 
@@ -489,6 +494,8 @@ static void inode_switch_wbs(struct inode *inode, int new_wb_id)
 	call_rcu(&isw->rcu_head, inode_switch_wbs_rcu_fn);
 	return;
 
+out_unlock:
+	spin_unlock(&inode->i_lock);
 out_free:
 	if (isw->new_wb)
 		wb_put(isw->new_wb);
