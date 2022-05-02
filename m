From: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: kernfs memcg accounting
Date: Mon, 2 May 2022 22:37:49 +0300
Message-ID: <7509fa9f-9d15-2f29-cb2f-ac0e8d99a948@openvz.org>
References: <7e867cb0-89d6-402c-33d2-9b9ba0ba1523@openvz.org>
 <20220427140153.GC9823@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=J7CBsRSCXXbD2/NTY2D5JamVPix8X/S/pKY0BP5yLBM=;
        b=t558DsrcLANHfzoqL9k9rSR9hcDj2jp1a50++NsDsBG6Kqz8P1S5fyIO6vJzyeSnPY
         jFiS4a0TeP4oHp5+RCGhQezFeLCtr+ShAPkOlDPoanNfqphdGAdeEsopDn1HP0uTtmzl
         C+C1HgrN9fh76OvW++baovvPOP1si22RlJzrXefq4EEQaldw/C+ijUjxUxttekLO0mOJ
         jcK/lL9vBtiDxfDMTyxX0gQLfAt6JOhU2s8V536Mf8LPQCzyog9upddfbV27W5pSPiGV
         VpoLsS+GyYSl1fM2UJsRtiQCnZP3f6aY9+34QzJxKXQrXyeRPYErVgH2Xhxj7Cev4prC
         BxYA==
Content-Language: en-US
In-Reply-To: <20220427140153.GC9823-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Florian Westphal <fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On 4/27/22 17:01, Michal Koutn=C3=BD wrote:
> Hello Vasily.
>=20
> On Wed, Apr 27, 2022 at 01:37:50PM +0300, Vasily Averin <vvs-GEFAQzZX7r8d=
nm+yROfE0A@public.gmane.org> wrote:
>> diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
>> index cfa79715fc1a..2881aeeaa880 100644
>> --- a/fs/kernfs/mount.c
>> +++ b/fs/kernfs/mount.c
>> @@ -391,7 +391,7 @@ void __init kernfs_init(void)
>>  {
>>  	kernfs_node_cache =3D kmem_cache_create("kernfs_node_cache",
>>  					      sizeof(struct kernfs_node),
>> -					      0, SLAB_PANIC, NULL);
>> +					      0, SLAB_PANIC | SLAB_ACCOUNT, NULL);
>=20
> kernfs accounting you say?
> kernfs backs up also cgroups, so the parent-child accounting comes to my
> mind.
> See the temporary switch to parent memcg in mem_cgroup_css_alloc().

Dear Michal,
I did not understand your statement. Could you please explain it in more de=
tails?

I see that cgroup_mkdir()->cgroup_create() creates new kernfs node for new
sub-directory, and with my patch account memory of kernfs node to memcg=20
of current process.
Do you think it is incorrect and new kernfs node should be accounted
to memcg of parent cgroup, as mem_cgroup_css_alloc()-> mem_cgroup_alloc() d=
oes?
Perhaps you mean that in this case kernfs should not be counted at all,
as almost all neighboring allocations do?

Thank you,
	Vasily Averin
