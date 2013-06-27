From: Anatol Pomozov <anatol.pomozov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cgroups: Do not show inactive devices in cgroups statistics
Date: Wed, 26 Jun 2013 17:37:38 -0700
Message-ID: <CAOMFOmVqevNSKgWR5keT8u7vsCRpHhYROejM6OucyNeeA6j6zQ@mail.gmail.com>
References: <1372274770-30679-1-git-send-email-anatol.pomozov@gmail.com>
	<20130626204540.GA4536@htj.dyndns.org>
	<20130626210820.GA17564@redhat.com>
	<CAOS58YP_Umud2DTY+3tc4m02FywGNOEALSN1An4OLXczcmsQ4Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=Ert6+36Aj0KaYkfTw7xeSKOlSy03vNm4YUq3AZJBPBk=;
        b=X7GRqxn+NNlfxr+rAH+mUHuMS9SXa6lMyEAEr+hlKVSIDSE2ST9VctQKdAHC+5tc6t
         Q8YhGxBQ0gQI9EOQTJCac7NCWXglEJlhUeV46/Xg5qxBRjttTNX9xJHlnMehLMWFGQjF
         cTj8Fo3Wu6oHjpSOJ/gGz+Uuwx6ETf6ONEZ7hyy57yphgcWC8jzzmEc8wZRbJC+veAUi
         5h7hVDoEae8r62i62xYtjTthCyx7gZGS+KQVL16pYkzgYdzwuPOOYi8PH8ng/SwenYa5
         paKE2J2ueFUC1/F+fQq3V+a6qURGpd7VJ2TL1UY80iFloUINTS5MpFLdL5MDCk7npLzW
         HdpQ==
In-Reply-To: <CAOS58YP_Umud2DTY+3tc4m02FywGNOEALSN1An4OLXczcmsQ4Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>

Hi

On Wed, Jun 26, 2013 at 2:11 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Wed, Jun 26, 2013 at 2:08 PM, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> I don't have an objection to not listing stats of devices which are
>> zero, but wondering why all the devices of system are showing in
>> cgroup stat.
>>
>> Don't we add a blkg to a blkcg only if that cgroup did some IO to
>> that particular device. If yes, then only those devices should
>> show to which cgroup did some IO and that should be non-zero.
>>
>> Is it because of hierarchical support where if a child does IO
>> to device, we will add an blkg instance to parent's cgroup? In
>> that case hierarchical stats will still be non-zero but group
>> local stat can be zero.
>
> I wondered that too.  Maybe they're configuring all combinations?  Anatol?

We use an io scheduler similar to cfq.

So I added a log to find place where the blkg is created. I found that
the structure is created on data write to CGROUP/weight_device CFQ
file. Now let's look at cfqg_set_weight_device() function (I am
looking at 3.5 sources but seems HEAD has the same issue). When we set
weight for a device in that group then an instance of cfq_group is
created for it. Here is the codepath from write() syscall to
cfq_pd_init() function:

[  119.584630]  [<ffffffff805001ba>] cfq_pd_init+0x10a/0x110
[  119.584634]  [<ffffffff804fce00>] blkg_alloc+0x110/0x130
[  119.584639]  [<ffffffff804fd098>] __blkg_lookup_create+0x278/0x3c0
[  119.584643]  [<ffffffff804fd1fb>] blkg_lookup_create+0x1b/0x40
[  119.584647]  [<ffffffff804fd433>] blkg_conf_prep+0x213/0x270
[  119.584669]  [<ffffffff805008ca>] cfqg_set_weight_device+0x4a/0xd0
[  119.584678]  [<ffffffff802c1118>] cgroup_write_string.isra.17+0xc8/0x130
[  119.584687]  [<ffffffff802c12d9>] cgroup_file_write+0x159/0x1e0
[  119.584707]  [<ffffffff8038aa4f>] vfs_write+0xaf/0x160
[  119.584711]  [<ffffffff8038add6>] sys_write+0x76/0x100
[  119.584716]  [<ffffffff807da672>] system_call_fastpath+0x16/0x1b


Bottom line: when we set weight for a device then it creates cfq_group
and initializes device stats with zero. Later that zero stat is shown
even if no activity happened on the device. Both CFQ and our custom IO
scheduler have this problem. And because we write set weight for all
devices in all cgroups we endup with a lot of zero useless stats.

What is the right fix in this situation?
