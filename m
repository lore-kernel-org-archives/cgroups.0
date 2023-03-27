From: Markus Elfring <Markus.Elfring@web.de>
Subject: Re: [PATCH] selftests: cgroup: Fix exception handling in
 test_memcg_oom_group_score_events()
Date: Mon, 27 Mar 2023 07:56:03 +0200
Message-ID: <c46dbb48-259b-1de9-2364-9bfaf1061944@web.de>
References: <f9303bdc-b1a7-be5e-56c6-dfa8232b8b55@web.de>
 <c383bdca-6f0d-4a75-e788-e1920faa0a62@web.de>
 <fffcd98a-bb73-41cd-8545-0f2c55dd38f9@lucifer.local>
 <5b7921c9-ee5d-c372-b19b-2701bcf33148@web.de>
 <20230326213900.GJ363182@maniforge>
Reply-To: Markus Elfring <Markus.Elfring@web.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cocci-owner@inria.fr>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=message-id:date:mime-version:to:cc:references:from:
   in-reply-to:content-transfer-encoding:subject:reply-to:
   sender:list-id:list-help:list-subscribe:list-unsubscribe:
   list-post:list-owner:list-archive;
  bh=NbwAOPMrDQxUEIt6QthT83wL1c/Cwpr53Iu46jtcHVo=;
  b=oUak/DxcVSCHF/kTRKzOWBR9Xw3JAaVEcKQOlWX64/MdaPv3CmmUAh2i
   XlDKca/gROF6VfPVafGkb8+9SVXnm2w5LdMYfCEDFA57vaun2Fwolf66I
   3B8RXFs5Why2wQkxAgAPbeL8ztvuwIxjHWhcTtd6IFldU842AzIMeW3M7
   Y=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de; s=s29768273;
	t=1679896565; i=markus.elfring@web.de;
	bh=pz/J0Hn4+9u+G26gPwGVXPtbTt3MxR2I7unMqST3Igg=;
	h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
	b=wVADs5LHX7spvpSubZ+v4nPIXGVfrzNkf8ibwxU2UHb06xMXH+EE/6JbxjYPzYIdY
	 znDbAvGe2zq0IWPd0BS72QMrKxIQdRsmnSwDz7SpjZ8uj7cqJsYRq9+uuGOB/w0y26
	 l9k6N7EYK6P9WDMLkHscHsra2HpIKCTXfwuHauD/CcQ2Tibk1ewrj6ZLSJ/ubpwPTt
	 zUK09KQc3VPIjHSjsqYhZ1nuMoi7YTWddo3HT57bBgKzFyrfJwbjS1nmFE3D/XJwI6
	 ptoVTvMAzAFyhi3E4I7ReXeuwL6NXj8r5F5/Ekc1VOODRMTuZGYaRIEmZqyxHq7OqA
	 JOKqtpnoKJ4Xg==
Content-Language: en-GB
In-Reply-To: <20230326213900.GJ363182@maniforge>
Errors-To: cocci-owner@inria.fr
Sender: cocci-request@inria.fr
List-Id: <cgroups.vger.kernel.org>
List-Help: <mailto:sympa_inria@inria.fr?subject=help>
List-Subscribe: <mailto:sympa_inria@inria.fr?subject=subscribe%20cocci>
List-Unsubscribe: <mailto:sympa_inria@inria.fr?subject=unsubscribe%20cocci>
List-Post: <mailto:cocci@inria.fr>
List-Owner: <mailto:cocci-request@inria.fr>
List-Archive: <https://sympa.inria.fr/sympa/arc/cocci>
Content-Type: text/plain; charset="utf-8"
To: David Vernet <void@manifault.com>, kernel-janitors@vger.kernel.org, linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Jay Kamat <jgkamat@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Muchun Song <muchun.song@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Lorenzo Stoakes <lstoakes@gmail.com>
Cc: cocci@inria.fr, LKML <linux-kernel@vger.kernel.org>

>> 2. Can a cg_destroy() call ever work as expected if a cg_create() call =
failed?
>
> Perhaps next time you can answer your own question by spending 30
> seconds actually reading the code you're "fixing":
>
> int cg_destroy(const char *cgroup)
> {
=E2=80=A6
>         ret =3D rmdir(cgroup);
=E2=80=A6
>         if (ret && errno =3D=3D ENOENT) <<< that case is explicitly hand=
led here
>                 ret =3D 0;
>
>         return ret;
> }

Is it interesting somehow that a non-existing directory (which would occas=
ionally
not be found) is tolerated so far?
https://elixir.bootlin.com/linux/v6.3-rc3/source/tools/testing/selftests/c=
group/cgroup_util.c#L285

Should such a function call be avoided because of a failed cg_create() cal=
l?

Regards,
Markus
