From: Tadeusz Struk <tadeusz.struk-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup: Use separate work structs on css release path
Date: Wed, 1 Jun 2022 17:00:44 -0700
Message-ID: <c3bd8e63-7204-f86d-8efa-254db71185fc@linaro.org>
References: <20220525151517.8430-1-mkoutny@suse.com>
 <20220525151517.8430-3-mkoutny@suse.com>
 <20220525161455.GA16134@blackbody.suse.cz> <Yo7KfEOz92kS2z5Y@blackbook>
 <Yo/DtjEU/kYr190u@slm.duckdns.org>
 <0babd7df-bdef-9edc-3682-1144bc0c2d2b@linaro.org>
 <Ypf0VnKUMiuRgZqT@slm.duckdns.org>
 <1fb4d8d7-ccc0-b020-715e-38c2dfd94c23@linaro.org>
 <Ypf5jpI7dSmpi4W0@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=dj5xSI3x7kYGymfT74GT+D5EgC5KBBiRdOQyucXrgA8=;
        b=BDEQtl4wDYFppmJ0FteRHhjnSzu730tXU7L8PyUwqpE8VTcccoPSo/aCpk1hfIEZ6M
         smyPyAncY17SE6CmMtsnP35N6zQBT+MjXGVM/2Y76G4slCjBMeToEr4Y0k3c7p7x/8j2
         xYziG5CerMPjkj2iVbzsBH183fRWTO1xpz9IrZkE5Rs3BHbxF0Eqe0lPQOo8oV0ondFE
         NDzi96z7nhvvWfDcr5SW4sBlG5MW8AECa7HoXhQyIkFGtRmE5pp/VnhFOhY6BbE+IB3B
         oCQI+aMwq4pMGlHxM+ll+YBzQkYStotkwhUhCz4jXo9cowL5ImVsu3FQcixpkAAxkWjL
         odEQ==
Content-Language: en-US
In-Reply-To: <Ypf5jpI7dSmpi4W0-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Bui Quang Minh <minhquangbui99-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On 6/1/22 16:43, Tejun Heo wrote:
> On Wed, Jun 01, 2022 at 04:37:17PM -0700, Tadeusz Struk wrote:
>> Yes, but as far as I can see the percpu_ref_kill_and_confirm(&css->refcnt, css_killed_ref_fn)
>> doesn't change the value of the refcnt, it just causes the css_killed_ref_fn() to be called
> 
> Yeah, the base ref is special for percpu_ref.
> 
>> on it. Only css_get() & css_put() modify the refcnt value.
>> And for the "free the thing" the css_killed_work_fn() does that.
>> It calls offline_css(css) and css_put(css) for the whole css hierarchy.
> 
> Yeah, the freeing path depends on the css_put(css) invoking css_release()
> which schedules the work item which actually frees. Am I misunderstanding
> something here?

What I'm trying to say is that it's not really a ref imbalance problem.
I think once the kill_css() has been called on a css, and it is enqueued to be
killed, we shouldn't call css_put(css) on it anymore outside of the "killed call
flow path". It will all be handled by the css_killed_ref_fn() function.

The fact the css_release() is called (via cgroup_kn_unlock()) just after
kill_css() causes the css->destroy_work to be enqueued twice on the same WQ
(cgroup_destroy_wq), just with different function. This results in the
BUG: corrupted list in insert_work issue.

-- 
Thanks,
Tadeusz
