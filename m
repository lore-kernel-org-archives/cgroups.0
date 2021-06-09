From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v9 8/8] writeback, cgroup: release dying cgwbs by
 switching attached inodes
Date: Wed, 9 Jun 2021 12:53:44 -0700
Message-ID: <YMEcSBcq/VXMiPPO@carbon.dhcp.thefacebook.com>
References: <20210608230225.2078447-1-guro@fb.com>
 <20210608230225.2078447-9-guro@fb.com>
 <20210608171237.be2f4223de89458841c10fd4@linux-foundation.org>
 <YMAKBgVgOhYHhB3N@carbon.dhcp.thefacebook.com>
 <YMANNhixU0QUqZIJ@google.com>
 <20210608223434.25efb827a66f10ad36f7fe0b@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=FQeSwqBYlXX2OUV6btAidyxpfyqTQcv817nZY36nqhg=;
 b=gSW2qH32u0MX2MrW1l/n4k7ywmmO7fG3RjuGz5kbDTDMxla6xDiIryrP9i1Y3gquJ2O6
 ZNdHQ1nQQ3DGh7o3KvTCumtgFdTcu+TkTFfKzWCpnYJXNeD9t4F3NrMRFY+w7bVN3jp+
 3wqf3/0PgAxGgrLtofNlQLOipkBIcx/IMg8= 
Content-Disposition: inline
In-Reply-To: <20210608223434.25efb827a66f10ad36f7fe0b@linux-foundation.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Dave Chinner <dchinner@redhat.com>, cgroups@vger.kernel.org

On Tue, Jun 08, 2021 at 10:34:34PM -0700, Andrew Morton wrote:
> On Wed, 9 Jun 2021 00:37:10 +0000 Dennis Zhou <dennis@kernel.org> wrote:
> 
> > On Tue, Jun 08, 2021 at 05:23:34PM -0700, Roman Gushchin wrote:
> > > On Tue, Jun 08, 2021 at 05:12:37PM -0700, Andrew Morton wrote:
> > > > On Tue, 8 Jun 2021 16:02:25 -0700 Roman Gushchin <guro@fb.com> wrote:
> > > > 
> > > > > Asynchronously try to release dying cgwbs by switching attached inodes
> > > > > to the nearest living ancestor wb. It helps to get rid of per-cgroup
> > > > > writeback structures themselves and of pinned memory and block cgroups,
> > > > > which are significantly larger structures (mostly due to large per-cpu
> > > > > statistics data). This prevents memory waste and helps to avoid
> > > > > different scalability problems caused by large piles of dying cgroups.
> > > > > 
> > > > > Reuse the existing mechanism of inode switching used for foreign inode
> > > > > detection. To speed things up batch up to 115 inode switching in a
> > > > > single operation (the maximum number is selected so that the resulting
> > > > > struct inode_switch_wbs_context can fit into 1024 bytes). Because
> > > > > every switching consists of two steps divided by an RCU grace period,
> > > > > it would be too slow without batching. Please note that the whole
> > > > > batch counts as a single operation (when increasing/decreasing
> > > > > isw_nr_in_flight). This allows to keep umounting working (flush the
> > > > > switching queue), however prevents cleanups from consuming the whole
> > > > > switching quota and effectively blocking the frn switching.
> > > > > 
> > > > > A cgwb cleanup operation can fail due to different reasons (e.g. not
> > > > > enough memory, the cgwb has an in-flight/pending io, an attached inode
> > > > > in a wrong state, etc). In this case the next scheduled cleanup will
> > > > > make a new attempt. An attempt is made each time a new cgwb is offlined
> > > > > (in other words a memcg and/or a blkcg is deleted by a user). In the
> > > > > future an additional attempt scheduled by a timer can be implemented.
> > > > > 
> > > > > ...
> > > > >
> > > > > +/*
> > > > > + * Maximum inodes per isw.  A specific value has been chosen to make
> > > > > + * struct inode_switch_wbs_context fit into 1024 bytes kmalloc.
> > > > > + */
> > > > > +#define WB_MAX_INODES_PER_ISW	115
> > > > 
> > > > Can't we do 1024/sizeof(struct inode_switch_wbs_context)?
> > > 
> > > It must be something like
> > > DIV_ROUND_DOWN_ULL(1024 - sizeof(struct inode_switch_wbs_context), sizeof(struct inode *)) + 1
> > 
> > Sorry to keep popping in for 1 offs but maybe this instead? I think the
> > above would result in > 1024 kzalloc() call.
> > 
> > DIV_ROUND_DOWN_ULL(max(1024 - sizeof(struct inode_switch_wbs_context), sizeof(struct inode *)),
> >                    sizeof(struct inode *))
> > 
> > might need max_t not sure.
> 
> Unclear to me why plain old division won't work, but whatever.  Please
> figure it out?  "115" is too sad to live!

You're totally right, plain division is fine here!
Please, squash the following chunk into the last commit in the series.

Thank you!

--

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 49b33300b1b8..545fce68e919 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -229,7 +229,8 @@ void wb_wait_for_completion(struct wb_completion *done)
  * Maximum inodes per isw.  A specific value has been chosen to make
  * struct inode_switch_wbs_context fit into 1024 bytes kmalloc.
  */
-#define WB_MAX_INODES_PER_ISW  115
+#define WB_MAX_INODES_PER_ISW  ((1024UL - sizeof(struct inode_switch_wbs_context)) \
+                                / sizeof(struct inode *))
 
 static atomic_t isw_nr_in_flight = ATOMIC_INIT(0);
 static struct workqueue_struct *isw_wq;
