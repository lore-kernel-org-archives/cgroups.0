From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v3 1/4] memcg: introduce per-memcg reclaim interface
Date: Fri, 8 Apr 2022 10:21:09 -0700
Message-ID: <CAJD7tkY8NwjOVeZX30Fc72kp5zRESBWRgXW3Ji-Owp0jjDuEbw@mail.gmail.com>
References: <20220408045743.1432968-1-yosryahmed@google.com>
 <20220408045743.1432968-2-yosryahmed@google.com> <YlA754XNFAmWQcm6@dschatzberg-fedora-PC0Y6AEN.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iM6uzIK2cRc6kF+XG8vLt5tKa+TcH20c4ZrUE/qi6/w=;
        b=lhsl/nELK+CjK9EjiqEgxM40CNFrd8O33D5yScOZeEFmN2mtYBl1RRyh7teoVon061
         kj8aY6QVT/NAOTigSUu8Y7225f3BAoDTOIFbFJkqfikA4nBu9W5zKfjzNjscVbUZpCEL
         TOfbFvs9CWUtBubunb4AJlZmBb5dRqOf9Yk4pxiGSjBWmoRGBB5QRajWXj9az8Q251gb
         crS7qVsWxwVcQFaYZGkjAOUYH9TaUrXMqf5Y/wuhESvfTMT3NyPb+tqY6eFtedGk1kHC
         uNhWX+utb/ZtxKPlsJceIR3VICKbc1+Hr9yOvb7P/hl/5YSRR9rMdsoD2qOcmmo91tnf
         ktpA==
In-Reply-To: <YlA754XNFAmWQcm6@dschatzberg-fedora-PC0Y6AEN.dhcp.thefacebook.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Schatzberg <schatzberg.dan@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeelb@google.com>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <roman.gushchin@linux.dev>, David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, Yu Zhao <yuzhao@google.com>, Dave Hansen <dave.hansen@linux.intel.com>, Wei Xu <weixugc@google.com>, Greg Thelen <gthelen@google.com>, Chen Wandun <chenwandun@huawei.com>, Vaibhav Jain <vaibhav@linux.ibm.com>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Tim Chen <tim.c.chen@linux.intel.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Fri, Apr 8, 2022 at 6:43 AM Dan Schatzberg <schatzberg.dan@gmail.com> wrote:
>
> On Fri, Apr 08, 2022 at 04:57:40AM +0000, Yosry Ahmed wrote:
> > +static ssize_t memory_reclaim(struct kernfs_open_file *of, char *buf,
> > +                           size_t nbytes, loff_t off)
> > +{
> > +     struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
> > +     unsigned int nr_retries = MAX_RECLAIM_RETRIES;
> > +     unsigned long nr_to_reclaim, nr_reclaimed = 0;
> > +     int err;
> > +
> > +     buf = strstrip(buf);
> > +     err = page_counter_memparse(buf, "", &nr_to_reclaim);
>
> Is there a reason not to support "max"? Empty string seems odd to me
> here.

We can certainly support "max" to reclaim as much as we can with
MAX_RECLAIM_RETRIES, if there are no objections from the maintainers.

>
> > +     if (err)
> > +             return err;
> > +
> > +     while (nr_reclaimed < nr_to_reclaim) {
> > +             unsigned long reclaimed;
> > +
> > +             if (signal_pending(current))
> > +                     break;
>
> I think this should be `return -EINTR;`

Yes this makes more sense. I think this was modeled after the if block
in memory_high_write(), but maybe it makes sense there to just report
success as the new high limit was set anyway.
Will change it in the next version.

>
> > +
> > +             reclaimed = try_to_free_mem_cgroup_pages(memcg,
> > +                                             nr_to_reclaim - nr_reclaimed,
> > +                                             GFP_KERNEL, true);
> > +
> > +             if (!reclaimed && !nr_retries--)
> > +                     break;
>
> Here you can just `return -EAGAIN;`

Will do.
>
> > +
> > +             nr_reclaimed += reclaimed;
> > +     }
> > +
> > +     return nr_reclaimed < nr_to_reclaim ? -EAGAIN : nbytes;
>
> Then this can just be `return nbytes;`

Will do.

>
> I'm very much in favor of this new interface. Thanks for working on
> it!

Thanks so much for reviewing it!
