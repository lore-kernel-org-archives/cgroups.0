From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup-v1: freezer: optionally killable freezer
Date: Tue, 24 Mar 2020 14:26:15 -0400
Message-ID: <20200324182615.GF162390@mtj.duckdns.org>
References: <20200219183231.50985-1-balejs@google.com>
 <20200303134855.GA186184@mtj.thefacebook.com>
 <CAKOZuevzE=0Oa8gn--rkVJ8t69S+o2vK--pki65XXg6EVuOhMQ@mail.gmail.com>
 <20200320201038.GB79184@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VKDCXEZ42UY913CTtFDT6Viou96lkFeyc6FJl6g05Vg=;
        b=AkI4Xkx1tlFJcJ9dNLecf4+W/yiyVYQzQJjxQEP3fsUyxtJlsDPsp2922A08nOHUqt
         Raz6pWjrCl2Hhym8BGoSwUNuuPSH9d7vYfRnfoGLRBR/CRLOXfi4zD6n1d5fSUpIvQFH
         G5SdqFXcT/F1KCp2Jmv8aiswNEn5y/cJFvk9n9q+ccGDLGwlnioNCKkDSHsNmzL95JtU
         pURc9Y4b8prbYmhRvfO+VUUnf+r33J9ni46guh0TYipbbdvAZhJ7v5nxJcAVMvEu04Wz
         kEBSWZbCndALY8ZvcfA6P1KQIOyEPipSsEPBC1fuESUBy2/Xy1bELlSr4o1v/OGJeB1M
         HkyQ==
Content-Disposition: inline
In-Reply-To: <20200320201038.GB79184@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marco Ballesio <balejs@google.com>
Cc: Daniel Colascione <dancol@google.com>, Roman Gushchin <guro@fb.com>, cgroups@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, rjw@rjwysocki.net, Pavel Machek <pavel@ucw.cz>, len.brown@intel.com, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, linux-pm@vger.kernel.org, Minchan Kim <minchan@google.com>, Suren Baghdasaryan <surenb@google.com>

Hello,

On Fri, Mar 20, 2020 at 01:10:38PM -0700, Marco Ballesio wrote:
> It might also be desirable for userland to have a way to modify the behavior of
> an already mounted v1 freezer.
> 
> Tejun, would it be acceptable to have a flag but disable it by default, hiding
> it behind a kernel configuration option?

Given how dead-end this is, I'm not sure this needs to be upstream. Can you give
me some rationales?

Thanks.

-- 
tejun
