From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] cgroup/cpuset: Make cpuset_fork() handle
 CLONE_INTO_CGROUP properly
Date: Mon, 3 Apr 2023 13:18:42 -0400
Message-ID: <d9f0005c-6825-b2a0-eac3-fcbad6e32b2f@redhat.com>
References: <20230331145045.2251683-1-longman@redhat.com>
 <20230331145045.2251683-2-longman@redhat.com>
 <20230403165523.aphsec2epqi72k27@blackpad>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680542324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f9kl6sR8CDHCLHRJZnldn58uw/G4gK2ubpkyUoDgp1A=;
        b=MioaBKWCgeHkpu2RUaIRi9vxNpSvchP05jY3t/53XHCo2hRfDQ7lQNVPvuTh4ytBzhe/fR
        i9CAYmwd8BP90YPHEuPMy/azmBN+OobX8MNeEnBgsAPKitK7fm96C4+FnRYrTSmTTiNBsZ
        9JoMCxRpp9NXvBIElh75yIKb8s3ct7I=
Content-Language: en-US
In-Reply-To: <20230403165523.aphsec2epqi72k27@blackpad>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, gscrivan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org


On 4/3/23 12:55, Michal Koutn=C3=BD wrote:
> On Fri, Mar 31, 2023 at 10:50:43AM -0400, Waiman Long <longman-H+wXaHxf7a=
LQT0dZR+AlfA@public.gmane.org> wrote:
>> By default, the clone(2) syscall spawn a child process into the same
>> cgroup as its parent. With the use of the CLONE_INTO_CGROUP flag
>> introduced by commit ef2c41cf38a7 ("clone3: allow spawning processes
>> into cgroups"), the child will be spawned into a different cgroup which
>> is somewhat similar to writing the child's tid into "cgroup.threads".
>>
>> The current cpuset_fork() method does not properly handle the
>> CLONE_INTO_CGROUP case where the cpuset of the child may be different
>> from that of its parent.  Update the cpuset_fork() method to treat the
>> CLONE_INTO_CGROUP case similar to cpuset_attach().
> Should .can_fork=3Dcpuset_can_fork in analogy to cpuset_can_attach be also
> devised? (Sorry if I missed that in the previous discussion.)

I have thought about that too.

However, the can_attach method checks only a couple of things:

1) PF_NO_SETAFFINITY flag - which won't be set in the case of fork() as=20
it is for kthread only.
2) DL bandwidth - Juri has a cpuset outstanding to modify the way this=20
check is being done. I want to wait until it is settled before tackling=20
this, if necessary.
3) security_task_setscheduler() - the CLONE_INTO_CGROUP code has already=20
checked that, we don't need to duplicate the check.

So we don't need a can_fork() check for now.

Cheers,
Longman

