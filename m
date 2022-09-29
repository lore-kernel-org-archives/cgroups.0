From: Gang Li <ligang.bdlg-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: Re: [RFC PATCH v1] mm: oom: introduce cpuset oom
Date: Thu, 29 Sep 2022 11:15:07 +0800
Message-ID: <19779c13-2db4-8273-8c7e-69fd51f5b71f@bytedance.com>
References: <20220921064710.89663-1-ligang.bdlg@bytedance.com>
 <18621b07-256b-7da1-885a-c96dfc8244b6@google.com>
 <Yy1kAnvowZh4ViP4@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=PPw35s/6IrjE9k5D5RV/GouQK31w+teLLRYYyCLRYOk=;
        b=v5ylXiRj+RiZTaBClX9KpUMT2fBnX7kdGoacLHRQ05aBEkMC9mXBSLwUVHfIfV/elX
         0bL9oAQD3ekTU9lW8axHBGe68HH7uYYx2449jrqDNPJiZTTH/rNKgOBkGfz8p0UbQOKl
         BT3M9eRS4r2yAxFw9ncdp5TgcCuh7LMOsR/3x8LCBZB+20JFL1LeW0fvZ7mmX2YQ5X3d
         jodFIEaXLhIqnk286MMbQpdmtVzqC9Z1pmIUoj+4iENdT8uCfAqiBMW/IsJpUMpYBbO1
         FF5UZvwanPmMgfsyo3tz3kn13iEWzo7JL+nseGutfqUb/+i5vH75tox45oyupgvzEozl
         pZBQ==
Content-Language: en-US
In-Reply-To: <Yy1kAnvowZh4ViP4-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On 2022/9/23 15:45, Michal Hocko wrote:
> Yeah, that is possible and something to consider. One way to go about
> that is to make the selection from all cpusets with an overlap with the
> requested nodemask (probably with a preference to more constrained
> ones). In any case let's keep in mind that this is a mere heuristic. We
> just need to kill some process, it is not really feasible to aim for the
> best selection. We should just try to reduce the harm. Our exisiting
> cpuset based OOM is effectivelly random without any clear relation to
> cpusets so I would be open to experimenting in this area.

In addition to cpuset, users can also bind numa through mbind(). So I
want to manage numa binding applications that are not managed by cpuset.
Do you have any ideas?
