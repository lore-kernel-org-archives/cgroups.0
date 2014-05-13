From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 5/7] cgroup: use restart_syscall() for retries after
 offline waits in cgroup_subtree_control_write()
Date: Tue, 13 May 2014 11:19:07 -0400
Message-ID: <20140513151907.GF23710@htj.dyndns.org>
References: <1399663975-315-1-git-send-email-tj@kernel.org>
 <1399663975-315-6-git-send-email-tj@kernel.org>
 <5371A6DB.2050908@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=mpx3aOyRHBbam6pAv/PQzdhqqYSjH6MVDTOCBZqG7g0=;
        b=pqvMyGS8mRDIwFnLQ3lMb4L36OjVwGtdjaaR+9xEKNqDjee5AhZttgHySol5XpCHAQ
         tdmmJqyvSX71PoKEPN96Fq+VUIvva5eS3sRSblJe2MhAbgpSELgDmcHNZ4Fw0V+a7Tfo
         dIkLFjBwK3j/xpJoMUgH/LdFfcvnFpn9GrB5pD2KyUtIa5HBaEb4QiweKxQnzK5oQGxc
         bVC/U0ihNTNIP59k8+9VqQB5XBpO7/VXvH/kZkzyp7nE05sp8mg1YzOPeU6M2zhEHnkn
         g14MFv+emEUh3L/QdrbVoexppfH7L//50mANse3E7HACIJhP7RWLRas+m4fzVw9//jLG
         Ag/w==
Content-Disposition: inline
In-Reply-To: <5371A6DB.2050908-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, May 13, 2014 at 01:00:11PM +0800, Li Zefan wrote:
> Hi Tejun,
> 
> On 2014/5/10 3:32, Tejun Heo wrote:
> > After waiting for a child to finish offline,
> > cgroup_subtree_control_write() jumps up to retry from after the input
> > parsing and active protection breaking.  This retry makes the
> > scheduled locking update more difficult.
> 
> Could you explain this sentence more specific? I don't understand what
> "scheduled locking update" means.

Updating it to "planned cgroup_tree_mutex removal".

Thanks.

-- 
tejun
