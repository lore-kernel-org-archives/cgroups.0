From: wang Yu <yuwang668899-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: memcg Can't context between v1 and v2 because css->refcnt not released
Date: Thu, 10 Aug 2017 16:26:23 +0800
Message-ID: <CADK2BfxJim8MvLPY497a+JAK2t9OTq+f1BY0o4qK0ihaWsoEMQ@mail.gmail.com>
References: <CADK2BfzM9V=C3Kk6v714K3NVX58Q6pEaAMiHDGSyr6PakC2O=w@mail.gmail.com>
 <20170810071059.GC23863@dhcp22.suse.cz> <CADK2BfwC3WDGwoDPSjX1UpwP-4fDz5fSBjdENbxn5XQL8y3K3A@mail.gmail.com>
 <20170810081920.GG23863@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=MTgN7nQEvH1H360bCrTWoaJOCrgTDYkAyRt/m5w1PLA=;
        b=WuPNPCSS0vK9kxbxLYIIhqnI99RGEEKkFOgUw0xME5f1Ec7bTWhYLlXGCL90MVjvkz
         A5X/DiTHxfbXUt9+i3ZU1q0l3lZZpeyYpxdr1hye7AJk/pg7ylVJZiE/L6JyOYhsc9J1
         D026id0Xxr2pBiPmVAZdRJvAaX9XFpZfc1hUH1mqzqTtIWX1b8fOLmjqXxm3j4Pq1yTH
         0zcmOPhvEhZjz7yxrZ0srHilKwMYzzRXBEUhULMUhjp05Cxb1VFm43Wt6o1Yu1YuvpX8
         9EBUjsuBl8vnasRKNmjJSEA23ZIvXA+vWPUfNwEARCP6LS5OxZlq+uq8kviim+drVtTT
         +63w==
In-Reply-To: <20170810081920.GG23863-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

2017-08-10 16:19 GMT+08:00 Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>:
> [Please do not top-post]
>
> On Thu 10-08-17 16:10:45, wang Yu wrote:
>> at first ,thanks for your reply.
>> but i also tested what you said, the problem is also.
>> force_empty only call try_to_free_pages, not all the pages remove
>> because mem_cgroup_reparent_charges moved
>
> Right. An alternative would be dropping the page cache globaly via
> /proc/sys/vm/drop_caches. Not an ideal solution but it should help.
> --
> Michal Hocko
> SUSE Labs

thanks again, but /proc/sys/vm/drop_caches can't solve it
you can try as follow

#cat /proc/cgroups

memory 11 2 1

#mkdir a

#echo 0 > a/cgroup.procs

#sleep 1

#echo 0 > cgroup.procs

#echo 1 > a/memory.force_empty

#echo 3 > /proc/sys/vm/drop_caches

#rmdir  a

#cat /proc/cgroups

memory 11 3 1
the  num_cgroups not decrease
