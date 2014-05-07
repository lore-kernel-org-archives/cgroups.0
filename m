From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH cgroup/for-3.15-fixes 1/2] cgroup: introduce task_css_is_root()
Date: Tue, 6 May 2014 23:29:55 -0400
Message-ID: <CAOS58YPN=nfJi7YyZrgQ+xnhhidrTL7RXmMXzzM61+M40d4LNw@mail.gmail.com>
References: <20140505223557.GU11231@htj.dyndns.org>
	<53699F6E.3070107@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date:message-id:subject
         :from:to:cc:content-type;
        bh=HzcqRjzk7AfxpzqRnoC650mVoCP5iPNWfva4DSS32Eg=;
        b=CZSdX9HR8/p+97CRxyg9jEDqXtcw+8+K1n8H36zClj+ucNbdSrtmQOHLUsCsGtFvHP
         +LyPRa41PQv/cSFR8YF/7Lp17yRzPZXqayP8uFhLoQ1Z1nrRXhTFK/c0xG53Jn11gvNe
         6wG3dYyQlL4A22rV6BoNmrhdURmHVtiFuSvUSEC5Fy995M0LVt/pFaYF9GLlZYnsNH2c
         1XkXdrYnMi4sd0mWkLpIDh+eakToS21MlDDc3rGUXNv4TMWIJDWxvh2+R3rg0Qelok48
         UaqYFtHqxfaSkJVhX2g0eKNwV3YaRXz4sZwFIQ3oGeZy+FHHBQITBHgBFfGah+r1OeKK
         Zt5Q==
In-Reply-To: <53699F6E.3070107-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello,

On Tue, May 6, 2014 at 10:50 PM, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
>> -static struct css_set init_css_set = {
>> +struct css_set init_css_set = {
>>       .refcount               = ATOMIC_INIT(1),
>>       .cgrp_links             = LIST_HEAD_INIT(init_css_set.cgrp_links),
>>       .tasks                  = LIST_HEAD_INIT(init_css_set.tasks),
>> @@ -356,6 +356,7 @@ static struct css_set init_css_set = {
>>       .mg_preload_node        = LIST_HEAD_INIT(init_css_set.mg_preload_node),
>>       .mg_node                = LIST_HEAD_INIT(init_css_set.mg_node),
>>  };
>> +EXPORT_SYMBOL_GPL(init_css_set);
>>
>
> Why do we export this symbol?

LOL because I forgot that we removed module support. I'll drop the EXPORT.

Thanks.

-- 
tejun
