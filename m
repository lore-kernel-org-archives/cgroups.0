From: "Chris Murphy" <chris-zXQU9YWDTqjmlV4oE/1sFAC/G2K4zDHf@public.gmane.org>
Subject: Re: oomd with 6.0-rc1 has ridiculously high memory pressure stats wit
Date: Fri, 26 Aug 2022 08:06:15 -0400
Message-ID: <a7a96563-fd07-4970-8c25-f0784c83c915@www.fastmail.com>
References: <d0df567c-1f6a-418d-8db7-3f777bd109c8@www.fastmail.com>
 <YwUcGvE/rhHEZ+KO@slm.duckdns.org>
 <9412f39b-9ec1-4542-944c-19577a358b97@www.fastmail.com>
 <0a6105f9-012a-4b75-b741-6549d7e169d8@www.fastmail.com>
 <YwU0mLBMuxpZ7Zwq@slm.duckdns.org>
 <f354bbb3-6619-4ab0-b0fb-a0098ffb0205@www.fastmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        colorremedies.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm2; t=1661515597; x=
        1661519197; bh=wb1n5fS7L6RXPJKttg8STGRunHj8c0XRsh6M4VcNCgM=; b=G
        APTEasDK+u5nysVOiR9MlQ8EQHl7WbSgWdTpqg80cu3ERl1Sr5ts++/uxGVuDnun
        xZhoTVvttSbIbLv57cx1h/EPeXBroKDJNoL/U2ELJ3OR8tU3AuBw83873MvHWoMO
        PSBhLgvH7ygYbb2t4zIv0+hCCNwRHPLsMzWacWt3HdKyEapY07djoJFBxof7AZEX
        8zSkVfEK44MiWISgNvjD9Vv/gs+n1HmE7L3gI4E2kfO52ZhqBZ6YVIEqhOSGiOfh
        YQtYSmk5W8lbCYrPeX+/2UZlnb5rOUgu3geoOy9TtaXat82rKUFeMDDJx5Z/P8ei
        h6uEGvy3vjm82C0DYktnw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1661515597; x=1661519197; bh=wb1n5fS7L6RXPJKttg8STGRunHj8
        c0XRsh6M4VcNCgM=; b=BkBPFOtWDKtu3IeKsN7SNq0onZJSg5jB73Wp+UJszxX6
        L0XldxixuvVAvyFI5slhRFc+/d83wAkUj+V3RL8qApaMnjARtAEwOUR6tlCqI4ql
        Pag0PNnkMGt908VbwmJmjPreO5+av+dhosYfoxg+G4FafzwSlHYI3MH0+uvx3m03
        2BdY2sGrInxTHjhYXJd96JGs5IXcLw1PNByhVQIC1mU3c+1xwuECilLtGOqeDjDR
        zdhgJHEAiOjWxF8iIfjry73lJq5buMB+axm48npyCackaj31uohH+h5E0qQbNpv4
        ep+7iut+a+oNvM5qDtllCaKB9gmDKMJjZouTiCiA3Q==
In-Reply-To: <f354bbb3-6619-4ab0-b0fb-a0098ffb0205-jFIJ+Wc5/Vo7lZ9V/NTDHw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Murphy <lists-zXQU9YWDTqjmlV4oE/1sFAC/G2K4zDHf@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>



On Wed, Aug 24, 2022, at 7:40 AM, Chris Murphy wrote:
> On Tue, Aug 23, 2022, at 4:12 PM, Tejun Heo wrote:
>> On Tue, Aug 23, 2022 at 02:59:29PM -0400, Chris Murphy wrote:
>>> Same VM but a different boot:
>>> 
>>> Excerpts:
>>> 
>>> /sys/fs/cgroup/user.slice/user-1000.slice/user-HmGangybm7RTDjBF/Jpztg@public.gmane.org/session.slice/gvfs-goa-volume-monitor.service/io.pressure:some avg10=3031575.41 avg60=56713935870.67 avg300=624837039080.83 total=18446621498826359
>>> /sys/fs/cgroup/user.slice/user-1000.slice/user-HmGangybm7RTDjBF/Jpztg@public.gmane.org/session.slice/gvfs-goa-volume-monitor.service/io.pressure:full avg10=3031575.41 avg60=56713935870.80 avg300=624837039080.99 total=16045481047390973
>>> 
>>> None of that seems possible.
>>> 
>>> io is also affected:
>>> 
>>> /sys/fs/cgroup/user.slice/user-1000.slice/user-HmGangybm7RTDjBF/Jpztg@public.gmane.org/session.slice/org.gnome.SettingsDaemon.Smartcard.service/io.pressure:full avg10=0.00 avg60=0.13 avg300=626490311370.87 total=16045481047397307
>>> 
>>> # oomctl
>>> # grep -R . /sys/fs/cgroup/user.slice/user-1000.slice/user-HmGangybm7RTDjBF/Jpztg@public.gmane.org/
>>> https://drive.google.com/file/d/1JoUxjQ2ribDvn5jmydCWXJdg0daaNScG/view?usp=sharing
>>> 
>>> We're going to try reverting 5f69a6577bc33d8f6d6bbe02bccdeb357b287f56 and see if it helps.
>>
>> Can you see whether the following helps?
>>
>> Thanks.
>>
>> diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
>> index ec66b40bdd40..00d62681ea6a 100644
>> --- a/kernel/sched/psi.c
>> +++ b/kernel/sched/psi.c
>> @@ -957,7 +957,7 @@ int psi_cgroup_alloc(struct cgroup *cgroup)
>>  	if (static_branch_likely(&psi_disabled))
>>  		return 0;
>> 
>> -	cgroup->psi = kmalloc(sizeof(struct psi_group), GFP_KERNEL);
>> +	cgroup->psi = kzalloc(sizeof(struct psi_group), GFP_KERNEL);
>>  	if (!cgroup->psi)
>>  		return -ENOMEM;
>
> Looks like it's fixed in limited testing. It'll get put into Rawhide 
> and automated testing today hopefully. 

Patch has been in Rawhide without any failures, consider it fixed. Thanks!


-- 
Chris Murphy
