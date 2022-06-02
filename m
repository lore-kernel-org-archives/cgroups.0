From: Tadeusz Struk <tadeusz.struk-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup: Use separate work structs on css release path
Date: Wed, 1 Jun 2022 17:40:51 -0700
Message-ID: <0fd1c3fd-fa86-dbed-f3f0-74c91b1efa11@linaro.org>
References: <20220525161455.GA16134@blackbody.suse.cz>
 <Yo7KfEOz92kS2z5Y@blackbook> <Yo/DtjEU/kYr190u@slm.duckdns.org>
 <0babd7df-bdef-9edc-3682-1144bc0c2d2b@linaro.org>
 <Ypf0VnKUMiuRgZqT@slm.duckdns.org>
 <1fb4d8d7-ccc0-b020-715e-38c2dfd94c23@linaro.org>
 <Ypf5jpI7dSmpi4W0@slm.duckdns.org>
 <c3bd8e63-7204-f86d-8efa-254db71185fc@linaro.org>
 <Ypf/MpwzByOrSp6A@slm.duckdns.org>
 <416dc60a-f0e5-7d05-1613-3cd0ca415768@linaro.org>
 <YpgEY/lJbLidLOhc@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=bCg75JCW+pfC2cBeuVcFJREBBHmfucnS3ebVUyU/JTo=;
        b=nvakCz5XU4OHW+crILNG26v7+vQ2IiR6NULuMci2uYtam+NThJ/3HpJrQJFMfg8a14
         Mqux8+tlKQRiYmlV6wq6o/Bwvjv63JmaCKuMD3fu2InTMyQscdIpanE/tjFmLJSdihfc
         dDqfD112MsNKtlgnntpgBLaMJHKh/NnByZpxbkseO5IHgidWzXLN1ccFm7YnOHm20b2t
         hwTzKwFPdaBmu67/KqpRwxh2Mqk4Y2fxy8TM5+nNQPIAPg2Hz1YEZ1OvwuiauFRp3Ysv
         wI3HHcEptwZcEIO5D6eY3mbSIq99WSH/HnNAlvUFfeRLa9oTmyvDXpWIijtl+2tBRKgy
         FP/w==
Content-Language: en-US
In-Reply-To: <YpgEY/lJbLidLOhc-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Bui Quang Minh <minhquangbui99-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On 6/1/22 17:29, Tejun Heo wrote:
> On Wed, Jun 01, 2022 at 05:26:34PM -0700, Tadeusz Struk wrote:
>> Ok the problem is that
>>
>> 1. kill_css() triggers css_killed_ref_fn(), which enqueues &css->destroy_work on cgroup_destroy_wq
>> 2. Last put_css() calls css_release(), which enqueues &css->destroy_work on cgroup_destroy_wq
>>
>> We have two instances of the same work struct enqueued on the same WQ (cgroup_destroy_wq),
>> which causes "BUG: corrupted list in insert_work"
> 
> #2 shouldn't be happening before kill_ref_fn() is done with the css. If what
> you're saying is happening, what's broken is the fact that the refcnt is
> reaching 0 prematurely.

css_killed_ref_fn() will be called regardless of the value of refcnt (via percpu_ref_kill_and_confirm())
and it will only enqueue the css_killed_work_fn() to be called later.
Then css_put()->css_release() will be called before the css_killed_work_fn() will even
get a chance to run, and it will also *only* enqueue css_release_work_fn() to be called later.
The problem happens on the second enqueue. So there need to be something in place that
will make sure that css_killed_work_fn() is done before css_release() can enqueue
the second job. Does it sound right?
  
>> So I think the easiest way to solve this would be to have two separate work_structs,
>> one for the killed_ref path and css_release path as in:
> 
> If you do that, you'd just be racing the free path against the kill path and
> the css might get freed while the kill path is still accessing it.
> 
> Thanks.
> 


-- 
Thanks,
Tadeusz
