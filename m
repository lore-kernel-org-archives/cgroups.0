From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 6/6] cgroup: update debug controller to print out thread
 mode information
Date: Wed, 19 Jul 2017 11:31:05 -0400
Message-ID: <20170719153105.GM3365493@devbig577.frc2.facebook.com>
References: <20170717020721.3612468-1-tj@kernel.org>
 <20170717020721.3612468-7-tj@kernel.org>
 <f6025fbf-bd53-dcd7-a5f7-d7e7a97da788@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qpZl7xz3Qgl0WJ6E6qF9yjv6gaGDlGpKg/+OwFO5avI=;
        b=IdMCYLhyWW9GQ0ipTfW8P6RQs63NK9+JCa1DWmXybXdHG45RPrb2vfGLnVJNeozoiH
         lNWmauQ2CWc2+NmWOnaYhm8MsT30CVNPPTRpZkgLdoxCKN29XmxRtCHd563GWzGRhTft
         p4Qiqwebps88gGBtfpY+gnP4XeMN4E0f0WmaaE1zXX7bYjD6vz7oZpzcf+Rq8Eu24SP/
         IcLSvr7Z6qf7v3rM2zOXEJ2HyqXYc6ID7Sh9KFaEObOKxEZBY9wKJs1R4ffzT9ucgqqS
         MRYcO2OKZsFnzR6Ro6HgdFWs8/ivyfCO29hW4X6LBWUFuIDxfzH9sDxX9wiuhJR3LkX2
         oCbQ==
Content-Disposition: inline
In-Reply-To: <f6025fbf-bd53-dcd7-a5f7-d7e7a97da788@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, peterz@infradead.org, mingo@redhat.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, guro@fb.com

Hello,

On Mon, Jul 17, 2017 at 05:19:16PM -0400, Waiman Long wrote:
> > +	if (cgroup_is_thread_root(css->cgroup))
> > +		seq_puts(seq, "[thread root]\n");
> > +	else if (cgroup_is_threaded(css->cgroup))
> > +		seq_puts(seq, "[threaded]\n");
> 
> The cgroup status will not be needed anymore as you have introduced the
> cgroup.type control file that returns the proper information.

Ah, right, will drop this file.

Thanks.

-- 
tejun
