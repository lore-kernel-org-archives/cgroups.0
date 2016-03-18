From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH for-linus 1/2] writeback, cgroup: fix premature wb_put() in
 locked_inode_to_wb_and_lock_list()
Date: Fri, 18 Mar 2016 13:50:03 -0400
Message-ID: <20160318175003.GA20028@mtj.duckdns.org>
References: <CAAeU0aMYeM_39Y2+PaRvyB1nqAPYZSNngJ1eBRmrxn7gKAt2Mg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7u4+PN17Jqy8l/GM0HpP5BVNpAv8YO09szILbDVhg2o=;
        b=ZhZjNH/JIiGt9fMZaUo8cldL/N0LuVM/vrW8bYRtQEX9tGBiJnCmpnVcsv0Fa/HnVr
         RRG9o1iY/NfeBFqHVaXcFHYGnRE/aY3NKlgcrOGHPyAP4w/+PFoU7rf3jz+wlp9dh4Ac
         AmlqipiPa04o4bQuUxSrHS26Ke6ugUaHZqFJLJvsiPa+VXFk0qQ3+LA4loZrMAhnbybq
         hpaTLqJa96oZQqlMPM047UYVuoZLL5ORlssQIQVOYQVuvqxQz8ik4d2JRVovP2IiIBAA
         zDbNzKOUI3BAVAIRFymxXCUGI8ZztT8GWwZuj/V1QmCnJwDi7ia0L+UB7K2hlMN9Spr2
         a6bw==
Content-Disposition: inline
In-Reply-To: <CAAeU0aMYeM_39Y2+PaRvyB1nqAPYZSNngJ1eBRmrxn7gKAt2Mg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tahsin Erdogan <tahsin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

locked_inode_to_wb_and_lock_list() wb_get()'s the wb associated with
the target inode, unlocks inode, locks the wb's list_lock and verifies
that the inode is still associated with the wb.  To prevent the wb
going away between dropping inode lock and acquiring list_lock, the wb
is pinned while inode lock is held.  The wb reference is put right
after acquiring list_lock citing that the wb won't be dereferenced
anymore.

This isn't true.  If the inode is still associated with the wb, the
inode has reference and it's safe to return the wb; however, if inode
has been switched, the wb still needs to be unlocked which is a
dereference and can lead to use-after-free if it it races with wb
destruction.

Fix it by putting the reference after releasing list_lock.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Fixes: 87e1d789bf55 ("writeback: implement [locked_]inode_to_wb_and_lock_list()")
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # v4.2+
Cc: Tahsin Erdogan <tahsin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
Hello,

Jens, two fixes for tricky brekages in cgroup writeback which can lead
lead to oops.  Both shouldn't affect !cgroup case at all.

Thanks.

 fs/fs-writeback.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -278,13 +278,15 @@ locked_inode_to_wb_and_lock_list(struct
 		wb_get(wb);
 		spin_unlock(&inode->i_lock);
 		spin_lock(&wb->list_lock);
-		wb_put(wb);		/* not gonna deref it anymore */
 
 		/* i_wb may have changed inbetween, can't use inode_to_wb() */
-		if (likely(wb == inode->i_wb))
-			return wb;	/* @inode already has ref */
+		if (likely(wb == inode->i_wb)) {
+			wb_put(wb);	/* @inode already has ref */
+			return wb;
+		}
 
 		spin_unlock(&wb->list_lock);
+		wb_put(wb);
 		cpu_relax();
 		spin_lock(&inode->i_lock);
 	}
