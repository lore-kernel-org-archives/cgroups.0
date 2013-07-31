From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 5/7] cgroup: remove struct cgroup_seqfile_state
Date: Wed, 31 Jul 2013 07:35:57 -0400
Message-ID: <20130731113557.GK2810@htj.dyndns.org>
References: <51F8C7C5.9040608@huawei.com>
 <51F8C829.3040708@huawei.com>
 <51F8D88B.2040400@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=u7frjb6lsYXvZ4vAh9DM0AOnJ4JfyG1Jg7t4Nq43H3o=;
        b=tGXIA1x73slj0NTKPoOlXzf/rEGOFOIfYB+5l7Vh4PEY+1XUhHEqOe51OBiIZ5pfMv
         TgsCQTJifsTKbwNCqo0TyieURntgTQT5f+lrpTZI0S/ZUpB150BQ08d3qzwoQqH1uQvA
         ZRQditzd53f9S3204nuBHIlUcQUCir/6luGCsExeOKtgeHNxh+SfX5cKFdZRNkSh994Q
         nJkk2SQgfYdk2jPbEy/9o9kg0A+RDcYW7D6cLSHJzIX4fhWcr9YUST99mGa6i4nER9sI
         b5tzze8C4AbpW2H8C5e7nFC2K0k3QEt5iAq4KL08LoGBh6aInlO68GoDJjHmInTfFOtB
         q4eg==
Content-Disposition: inline
In-Reply-To: <51F8D88B.2040400-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Jul 31, 2013 at 05:27:39PM +0800, Li Zefan wrote:
> >  static int cgroup_seqfile_release(struct inode *inode, struct file *file)
> >  {
> > -	struct seq_file *seq = file->private_data;
> > -	kfree(seq->private);
> >  	return single_release(inode, file);
> >  }
> 
> Oh, I just realized now we can remove cgroup_seqfile_release().
> 
> Will send out an updated patch...

Applied the updated patch.  Can you please post updated patches as
replies to the original path from next time?  That makes things easier
to track on my side.

Thanks.

-- 
tejun
