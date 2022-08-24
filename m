From: "Chris Murphy" <lists-zXQU9YWDTqjmlV4oE/1sFAC/G2K4zDHf@public.gmane.org>
Subject: Re: oomd with 6.0-rc1 has ridiculously high memory pressure stats wit
Date: Wed, 24 Aug 2022 07:40:03 -0400
Message-ID: <f354bbb3-6619-4ab0-b0fb-a0098ffb0205@www.fastmail.com>
References: <d0df567c-1f6a-418d-8db7-3f777bd109c8@www.fastmail.com>
 <YwUcGvE/rhHEZ+KO@slm.duckdns.org>
 <9412f39b-9ec1-4542-944c-19577a358b97@www.fastmail.com>
 <0a6105f9-012a-4b75-b741-6549d7e169d8@www.fastmail.com>
 <YwU0mLBMuxpZ7Zwq@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        colorremedies.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm2; t=1661341226; x=
        1661344826; bh=e8VH2Kk8ncrPNHZi3c++JZcHD93/Vywl4g4DsjOv9gk=; b=B
        OvUm8PuRrxai3Q8wESMEtG3XtpaQvTpxSXS6vuknUciSZTFQvVSeg0sdbd0ZLPQ0
        G3nlZcu3dlULyBT8+0wbEXVfUNgDUD/QTTjvgdWVveA4My+y9B5TZcG7Vmy4zQAA
        Bh6h7YmwrV9F1c8qnT+FrwiGwkJzIEK+WPRC4WSsscMNWihQtrFI3QXhPWViedS6
        sGo8kQceWRVL6xDbhQOaLit4WVji75EKemTCw2py+dReqWLnVdFqWhlXAVUUj3jn
        zbp+7L/pZQf5lutOqeNMJlDlCValdarwJ/6jhNF+Z+U0v1qemNpSfcWwfW4CXJgu
        NRxkRSIHPXR/nAN8uRMJA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1661341226; x=1661344826; bh=e8VH2Kk8ncrPNHZi3c++JZcHD93/
        Vywl4g4DsjOv9gk=; b=w3CJ3B5+BX2Tw75VIvXL5uYZTeaeFOAj59hKF23FOfu8
        w7Yzu0u1iLF2HLeH0XAdB183OmfkHUsKBeMalaH9jrFjrJKy/+wBU/m7ITFq+GJA
        e6uljsENK0wnIe7JkqvCbC1zWSRp2dlI8G5OtBJt8FGUNUbszR4UMvFZZWir+Hfy
        WbWimr12cQ4pZsccjbT3lrudrH3YehieMRAc7Z8e0dbYjpDprkDXR20B8NXUZe1S
        9O+dAQ0DekoRBOdQD1WnHlaMOawdz4EIpXdeAxFIdLW66B1Pp2Cod8uzris654ph
        DdasJ24L5Tdt2ztS1LRigW3OR3yFn8hWBP037JyelQ==
In-Reply-To: <YwU0mLBMuxpZ7Zwq-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>



On Tue, Aug 23, 2022, at 4:12 PM, Tejun Heo wrote:
> On Tue, Aug 23, 2022 at 02:59:29PM -0400, Chris Murphy wrote:
>> Same VM but a different boot:
>> 
>> Excerpts:
>> 
>> /sys/fs/cgroup/user.slice/user-1000.slice/user-HmGangybm7RTDjBF/Jpztg@public.gmane.org/session.slice/gvfs-goa-volume-monitor.service/io.pressure:some avg10=3031575.41 avg60=56713935870.67 avg300=624837039080.83 total=18446621498826359
>> /sys/fs/cgroup/user.slice/user-1000.slice/user-HmGangybm7RTDjBF/Jpztg@public.gmane.org/session.slice/gvfs-goa-volume-monitor.service/io.pressure:full avg10=3031575.41 avg60=56713935870.80 avg300=624837039080.99 total=16045481047390973
>> 
>> None of that seems possible.
>> 
>> io is also affected:
>> 
>> /sys/fs/cgroup/user.slice/user-1000.slice/user-HmGangybm7RTDjBF/Jpztg@public.gmane.org/session.slice/org.gnome.SettingsDaemon.Smartcard.service/io.pressure:full avg10=0.00 avg60=0.13 avg300=626490311370.87 total=16045481047397307
>> 
>> # oomctl
>> # grep -R . /sys/fs/cgroup/user.slice/user-1000.slice/user-HmGangybm7RTDjBF/Jpztg@public.gmane.org/
>> https://drive.google.com/file/d/1JoUxjQ2ribDvn5jmydCWXJdg0daaNScG/view?usp=sharing
>> 
>> We're going to try reverting 5f69a6577bc33d8f6d6bbe02bccdeb357b287f56 and see if it helps.
>
> Can you see whether the following helps?
>
> Thanks.
>
> diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
> index ec66b40bdd40..00d62681ea6a 100644
> --- a/kernel/sched/psi.c
> +++ b/kernel/sched/psi.c
> @@ -957,7 +957,7 @@ int psi_cgroup_alloc(struct cgroup *cgroup)
>  	if (static_branch_likely(&psi_disabled))
>  		return 0;
> 
> -	cgroup->psi = kmalloc(sizeof(struct psi_group), GFP_KERNEL);
> +	cgroup->psi = kzalloc(sizeof(struct psi_group), GFP_KERNEL);
>  	if (!cgroup->psi)
>  		return -ENOMEM;

Looks like it's fixed in limited testing. It'll get put into Rawhide and automated testing today hopefully. Thanks!

-- 
Chris Murphy
