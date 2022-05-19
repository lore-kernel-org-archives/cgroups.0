From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 4/4] memcg: enable accounting for allocations in
 alloc_fair_sched_group
Date: Thu, 19 May 2022 18:45:11 +0200
Message-ID: <20220519164511.GI16096@blackbody.suse.cz>
References: <Ynv7+VG+T2y9rpdk@carbon>
 <30f5b95a-db87-3924-6ad0-4c302c924ff0@openvz.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1652978712; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U548y7wH3UcsDxDWZRXnGHjViQr6zgFmh8zCYvycdiI=;
        b=Cu+15Ol8cSpfF+0sMpGHKwf5JY2TgPwNb4aI2LyBnrGh05KVKNa+xwHCMwRjVuYlVtN6Bg
        Zuq1AJc8AFOTAzyfDC7Dnd5ePTDhwqfxjdCFXNno+uhJ9zQXO9Zubt7pG/OXW8sl1uxRLg
        5/Br8Y58aNwYBb6W8ZvgEUQEAygW7Kk=
Content-Disposition: inline
In-Reply-To: <30f5b95a-db87-3924-6ad0-4c302c924ff0-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, May 13, 2022 at 06:52:20PM +0300, Vasily Averin <vvs-GEFAQzZX7r8dnm=
+yROfE0A@public.gmane.org> wrote:
>  kernel/sched/fair.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Reviewed-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>
