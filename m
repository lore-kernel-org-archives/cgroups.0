From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup/cpuset: Optimize cpuset_attach() on v2
Date: Mon, 21 Nov 2022 14:11:03 -0500
Message-ID: <78de73b0-2a27-592b-b70b-ca209962fdef@redhat.com>
References: <20221112221939.1272764-1-longman@redhat.com>
 <20221112221939.1272764-3-longman@redhat.com>
 <20221121185042.GA15225@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669057871;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pCmAWoY/E+D1EdQWKofo3IS5cplA0bKml9JOCiXWhTQ=;
        b=P8yOsBNsJms5T9BTfHTQbcQdN5NkdVgbRcJ9HAw38mOr0lh7l5iNrTeN4QJau6EEfggqfH
        Oxdd4YoLT8b39Y1DYa+AHBOLciS5bSCa6A7ZL1RJHffqpvZ4l8JG8XWQQecYBN2QqZ4KFf
        5HLv0o+qNQjOZG/Tu/eknzwUhsyOgdY=
Content-Language: en-US
In-Reply-To: <20221121185042.GA15225-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>


On 11/21/22 13:50, Michal Koutn=C3=BD wrote:
> On Sat, Nov 12, 2022 at 05:19:39PM -0500, Waiman Long <longman-H+wXaHxf7a=
LQT0dZR+AlfA@public.gmane.org> wrote:
>> +	/*
>> +	 * In the default hierarchy, enabling cpuset in the child cgroups
>> +	 * will trigger a number of cpuset_attach() calls with no change
>> +	 * in effective cpus and mems. In that case, we can optimize out
>> +	 * by skipping the task iteration and update.
>> +	 */
>> +	if (cgroup_subsys_on_dfl(cpuset_cgrp_subsys) &&
>> +	    !cpus_updated && !mems_updated) {
> I'm just wondering -- why is this limited to the default hierarchy only?
> IOW why can't v1 skip too (when favorable constness between cpusets).

Cpuset v1 is a bit more complex. Besides cpu and node masks, it also=20
have other flags like the spread flags that we need to looks for=20
changes. Unlike cpuset v2, I don't think it is likely that=20
cpuset_attach() will be called without changes in cpu and node masks.=20
That are the reason why this patch focuses on v2. If it is found that=20
this is not the case, we can always extend the support to v1.

Cheers,
Longman

