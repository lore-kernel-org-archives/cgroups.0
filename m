From: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Patch v2 3/3] mm/memcg: add next_mz back to soft limit tree if
 not reclaimed yet
Date: Mon, 14 Mar 2022 23:05:48 +0000
Message-ID: <20220314230548.wo4colcwqxhhf3mx@master>
References: <20220312071623.19050-1-richard.weiyang@gmail.com>
 <20220312071623.19050-3-richard.weiyang@gmail.com>
 <Yi8NudEX/sZsO2nO@dhcp22.suse.cz>
Reply-To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Qviwn+qqmEMoumEZT2BJtbr5DY+V57MiiCdripFWHEs=;
        b=oWwPhqNJsbdbfbBEvYxrbM0l6Anq0/f5kesf3PtfoAYrvrPg0pv3IZh1/A9zTnTx++
         eWJ/nZLUEdArGsuk25+IHuZA6tO1dK2E8uTUfmZzYzSJ28Oya28iZ1W74uc0T5DcfmZG
         RI5GDkYYG4dKRoL6xf34peOMoUHy2JqYZoSbzHkg3wNLPo5fEoFsn3pOcZ0m2nW2AFtB
         S02gITXU151YZ7SeK9tv+xerQaq4J/IF2de6aMO1Qd/gYePQlogovXbOmGIP9kMz8JRm
         ZfaGBrHO1Vy2N4tKxhclnKj074FuOSdgE0zQQxk0SynlzkCIScyZZQTgsZmysNBjnPPF
         JQcg==
Content-Disposition: inline
In-Reply-To: <Yi8NudEX/sZsO2nO-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Mon, Mar 14, 2022 at 10:41:13AM +0100, Michal Hocko wrote:
>On Sat 12-03-22 07:16:23, Wei Yang wrote:
>> When memory reclaim failed for a maximum number of attempts and we bail
>> out of the reclaim loop, we forgot to put the target mem_cgroup chosen
>> for next reclaim back to the soft limit tree. This prevented pages in
>> the mem_cgroup from being reclaimed in the future even though the
>> mem_cgroup exceeded its soft limit.
>> 
>> Let's say there are two mem_cgroup and both of them exceed the soft
>> limit, while the first one is more active then the second. Since we add
>> a mem_cgroup to soft limit tree every 1024 event, the second one just
>> get a rare chance to be put on soft limit tree even it exceeds the
>> limit.
>
>yes, 1024 could be just 4MB of memory or 2GB if all the charged pages
>are THPs. So the excess can build up considerably.
>
>> As time goes on, the first mem_cgroup was kept close to its soft limit
>> due to reclaim activities, while the memory usage of the second
>> mem_cgroup keeps growing over the soft limit for a long time due to its
>> relatively rare occurrence.
>> 
>> This patch adds next_mz back to prevent this sceanrio.
>> 
>> Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
>Even though your changelog is different the change itself is identical to
>https://lore.kernel.org/linux-mm/8d35206601ccf0e1fe021d24405b2a0c2f4e052f.1613584277.git.tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org/
>In those cases I would preserve the the original authorship by
>From: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>and add his s-o-b before yours.

TBH I don't think this is fair.

I didn't see his original change before I sent this patch. This is a
coincidence we found the same point for improvement.

It hurts me if you want to change authorship. Well, if you really thinks this
is what it should be, please remove my s-o-b.

>
>Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
>
>Thanks!

-- 
Wei Yang
Help you, Help me
