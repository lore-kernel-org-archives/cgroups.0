From: Tadeusz Struk <tadeusz.struk-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup: Use separate work structs on css release path
Date: Wed, 1 Jun 2022 17:26:34 -0700
Message-ID: <416dc60a-f0e5-7d05-1613-3cd0ca415768@linaro.org>
References: <20220525151517.8430-1-mkoutny@suse.com>
 <20220525151517.8430-3-mkoutny@suse.com>
 <20220525161455.GA16134@blackbody.suse.cz> <Yo7KfEOz92kS2z5Y@blackbook>
 <Yo/DtjEU/kYr190u@slm.duckdns.org>
 <0babd7df-bdef-9edc-3682-1144bc0c2d2b@linaro.org>
 <Ypf0VnKUMiuRgZqT@slm.duckdns.org>
 <1fb4d8d7-ccc0-b020-715e-38c2dfd94c23@linaro.org>
 <Ypf5jpI7dSmpi4W0@slm.duckdns.org>
 <c3bd8e63-7204-f86d-8efa-254db71185fc@linaro.org>
 <Ypf/MpwzByOrSp6A@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=y/gUgyMqWVcRsb+qEaGqa2cDEAVvpf+gfqD2gAKhZeo=;
        b=ItJwGzxeN7XJZuLKJ256vI76Qq2frqb9PjiPVfBOpWWW17LMKIqeeRXz/25pC8lXlQ
         GitrNQa5fCz82T6DMO0vkedLn7U6JEuYtbxflHVlzTWKVG+6DfJoQxGqYsnZ/+xP9M0k
         Y7vZ5P/Z+2irYU+pexBhC5bauIguFdJ0qJBwDxzCT1wlq/P3ppsnYXpBuS95KARPlcjP
         FlI6j+lIHVhfn+dpit9oxJno2DbgUK5gInvdPa2lFd/bs0Tl81/oY4zMhiGoGmRhLkd7
         mYXwcPEN+ZjzzMbHQxFOX8qgBNv3rbCp12Yn+M6Pc2+80NKRZ26j2Va+6/pXWTomYiPn
         DoSg==
Content-Language: en-US
In-Reply-To: <Ypf/MpwzByOrSp6A-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Bui Quang Minh <minhquangbui99-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On 6/1/22 17:07, Tejun Heo wrote:
> Hello,
> 
> On Wed, Jun 01, 2022 at 05:00:44PM -0700, Tadeusz Struk wrote:
>> What I'm trying to say is that it's not really a ref imbalance problem.
>> I think once the kill_css() has been called on a css, and it is enqueued to be
>> killed, we shouldn't call css_put(css) on it anymore outside of the "killed call
>> flow path". It will all be handled by the css_killed_ref_fn() function.
>>
>> The fact the css_release() is called (via cgroup_kn_unlock()) just after
>> kill_css() causes the css->destroy_work to be enqueued twice on the same WQ
>> (cgroup_destroy_wq), just with different function. This results in the
>> BUG: corrupted list in insert_work issue.
> 
> I have a hard time following here. The kill / release paths relationship
> isn't that complicated. The kill path is invoked when the percpu_ref's base
> ref is killed and holds an extra ref so that it's guaranteed that release
> can't happen before the kill path is done with the css. When the final put
> happens - whether that's from the kill path or someone else, which often is
> the case - the release path triggers. If we have release getting scheduled
> while the kill path isn't finished, it is a reference counting problem,
> right?
> 
> Can you elaborate the exact scenario that you think is happening? Please
> feel free to omit the function calls and all that. Just lay out who's doing
> what.

Ok the problem is that

1. kill_css() triggers css_killed_ref_fn(), which enqueues &css->destroy_work on cgroup_destroy_wq
2. Last put_css() calls css_release(), which enqueues &css->destroy_work on cgroup_destroy_wq

We have two instances of the same work struct enqueued on the same WQ (cgroup_destroy_wq),
which causes "BUG: corrupted list in insert_work"

So I think the easiest way to solve this would be to have two separate work_structs,
one for the killed_ref path and css_release path as in:

https://lore.kernel.org/all/20220523212724.233314-1-tadeusz.struk-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org/

-- 
Thanks,
Tadeusz
