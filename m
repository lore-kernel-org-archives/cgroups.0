Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792437139;
	b=m7phwfqlVsHvgwUZakEC/C07K4omhyhEocM2BQGosisxh4ntjarxLqi7yWbhbr9dZ7EN
	 lNx0ati5iRVapUYndAcgUJAC2el13XO3hotq8rHypTAt8QuKyDp0aqmjIqqc6evXDTGlh
	 Pd765IUP77UcUC9B1zbfgu4wow+dRF9mcvoMKnIn1pNi67iSqZHI44KX0DM1iPrdyfDqV
	 brDN/JYkYuw9l3tqeGWfPXIijWqmsOaR6lwIBxdMz8B4rQoWxdKQ+nEYh5ubrcPoqXdWz
	 JMoFJzQJW0JS1fA3WEWdRDLWH2eIcCyZp8Zd/Q8a+UD87OV5cOF708mF2Hr87kG8zzA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792437139;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=brXSmDy6U/oRKvH40grJe8uDEK1S7rGaavMW9jk3fYA=;
	b=DKgzW/iHOhe3V38HMyzRt7870mB9fBsVzOfxG0iqDRpU4qySsCVLfxhxq+ezMfVDVR0O
	 +Zuhc7KQDK96Grzqu3BonaW2wVUF3viHRToXAByFVQTlP95TSvE2gWBjYA5Xz1gG62h8o
	 4J3zPJLNcgqbjzjvwVgKaJ4SZKHUKnP2OiacwCL+TpiNOzBrGTyAQiGVzXy+WyPNcb0xE
	 OtaPSiuP2m4k7Nn9nX0Offv9kxTZtmwW7juVzqL5S33bn+k2gL8gvIF2BJ61DnWuBrtcl
	 G3o3u7vXv+ieHxeW48zq/Pu9w00oYNv1c4sMQMjXHr2SSgUPX8/Ppu5v1UHQC+/b6ig==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=soleen.com;
	spf=pass smtp.mailfrom=soleen.com;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.47
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9C8606A31E
	for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 19:12:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9D9C8606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6b3dd83e779so1052450a12.1
        for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 12:12:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792437132; cv=none;
        d=google.com; s=arc-20260327;
        b=MWc6lIjp+rB/rFq5Nwbs+8wIiHgRi1IkyAr35DtrpGM6mAE7GFnTnDq0X9Fona6et5
         gdozqQW9QndA9ls71oRLdLmMYW7ckWE+wdh+mKeApxsrphBfoTGHFE+gymxvfYH52wHb
         2z+sCxqNVDEN7UCtr2C0K9gQac1dfSNEo7mV5zCILc7LqI1PFNqLvTt4LacwuXIsR2wU
         XgG1mqgou7+oRgskHqiCA5kKVWsL81fTxGYbEXV/jQjm5O+iHkkQpNbchcQm/QVG0Ohy
         eajxnvs3nU81Ao9cvbabCXL4JDeX9O2G7lM750iSz4Hfp/xtQGJclXb5zYkECa5HRdaJ
         bd5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=brXSmDy6U/oRKvH40grJe8uDEK1S7rGaavMW9jk3fYA=;
        fh=7H7AhMXua/WKmKxITBHyNLvntB+gnLD1r5FdKUBPbt8=;
        b=idU8jWOEJ383XJuC5qMZ+vdo7CZnN+6oMPX60GxCDSzxLU5sgS4ktwjoSIaFtThOln
         v9UkY97REE3Aac0lIOcl1gswttKZMBibjh9e+zREBWmRk97jq5R9R7j0DqNqufjmixxq
         a69+go7n99mVyr23XMS1hLuys44d0Cxt/sfjgBKBvPFqzWUuBeYYlPUwNqTHFBKsqnYw
         NFc2A4VDuL3+OZeS8CWn9MwN/cNT/iubCcIWRV9PfbYwbHPrhvHey0CJ5KwivwuZrtGo
         G/iFKCGF8sN6CwCYCVwG+UGwgJ/br6r1T250RZZCpdg7NTrEAaL0YEsm1VXurqDJXeMJ
         VfmA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792437132; x=1793041932; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=brXSmDy6U/oRKvH40grJe8uDEK1S7rGaavMW9jk3fYA=;
        b=U/c9xgEk3/Yk28zW/sfw2QYvml8TEfstWHoaPBquHhyY6UjwLmbpz7aQwVI8wYL8jx
         zgstEWorkWpU26FA+0IPmZV+xJOVpD+WfTIGCkjgN64xf9JJLpG9EFFFX3iZ2R7yaBsk
         7OiYgsYg7i24gbhDaiAETBXKZc5mnWw0Clct7eDsNODBQauPSNqEL6Q9FS/szQa+9KWN
         aHWyF7tdw7bVfvTicTuox6CL0URzzeJ6BuOpiwRXt5jOdcAtcNBvG1rAGVwC5E0w411Y
         UqqYwO97E9moWWPlsq+cQhGxFzQzfqxJYgiuHOm9wBR93rRwd/vd27CAVityd/i3Vg2n
         GJ8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792437132; x=1793041932;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=brXSmDy6U/oRKvH40grJe8uDEK1S7rGaavMW9jk3fYA=;
        b=rk87T+n8NK/GheEiyA+P1a7O0OjUC2Zvd7XfwMoMwz4agRsDkL3cQOt6zgBJjWeHjC
         qXMe5ucMpi55wf4GyAi2ApakjKpmyQQXfmp9yJtKF8u3861jWuXMMxy/0tcvgcCTbySv
         ZdiEfX8dHp2kVk0ZbWGGaYvhnHTpagxsdPWoDzJnjnb2bAKSCh8lFj/B4MMnQ268neXf
         M6Qe9jEMmaoTjL7J1K4fLdD6By35nTf7ze8en/ZYgkvh+L32x9e5So9BSiPiVF4X9D/9
         6La/FShlgoPdCR2bi84whP0u4BSzicQi35xLUnp2ecTHoqcQ46BVOeCaNH6hrsL1gxqs
         OxeQ==
X-Forwarded-Encrypted: i=1; AKwUvBxNEc5mUFCjFLWynKSuBwuVBoqrSTKIHFi4F/l2aEMcZNqeco8ZbZEtBWVxKEe8Jh2Nub095TSE@vger.kernel.org
X-Gm-Message-State: AFq9FYJ6Ztn6dVoEyfaej1EpSejilpSH5Xf0FGhOtp+PZI2f52ZuL3Pi
	h30cxzELrq51gKBqgBPNCuV8gnqTs529lpD4EFt4yh0zJjqgVel0vbePjQLqRu6dn6jLEYY6iCL
	h5tshgXukW0+SNfx4oQstKK9isWPWk/Z//7ubKlU0OQ==
X-Gm-Gg: AYBFou02NLAvFmW7aGiDvJYarTF5CfNL5a38rWIOUWgD701U1ov3S3YLxKBmIPkC1pw
	UDsm7vh1I4bdp9I8d5McdlNbxPDRfXbnfWro77cWG2xb8CSIb/wkQmgLU+LPjUCd7P2z2N0+egF
	Dx4Vn/PJYuJt5tmj4P4mEQ2wVIEOQmD1djUSNkj55ooPdYOoURA05qYhNjm5pME0JJRj/eLN1x0
	2KQLiaIDvac/WXUCO93MhAMZ1zwbQzhaEFENHnjteyZcD+Pn6VI9RKsQcXARlmhtmkNb1E2jax2
	q3+w4JyQGP9KcZXvi+dJs3ikSEG4X3otUGw/M1D47bhI8yrmwcVf0Bq2P80pVX6+UuG5kowFIAn
	thd62w8grxeVOFjnXJfYeyqUU+gLAbmqik4j9QQAl+K15jjPZ89dJQOzkpPgGOsaixPZHIId4vo
	Yk5mS9Q5mk/p7v
X-Received: by 2002:a05:6402:a295:20b0:6b1:c6ad:ae3f with SMTP id
 4fb4d7f45d1cf-6b3a8199b12mr3606189a12.35.1792437131823; Mon, 19 Oct 2026
 12:12:11 -0700 (PDT)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261019011446.834487-1-pasha.tatashin@soleen.com> <SJ1PR11MB608365E406C4DA7CB91858A4FC982@SJ1PR11MB6083.namprd11.prod.outlook.com>
In-Reply-To: <SJ1PR11MB608365E406C4DA7CB91858A4FC982@SJ1PR11MB6083.namprd11.prod.outlook.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 19 Oct 2026 15:11:32 -0400
X-Gm-Features: AclHuK81i0D--1zvoLFLDSEjKdb8OtLyg3_R_Omdu6BLSuefBq3mveb_0VEz-04
Message-ID: <CA+CK2bAQr=Ak1u-Aiwbw=DZ22Nk8oRDqnC2AnRaez7nOyJj0-w@mail.gmail.com>
Subject: Re: [PATCH v2 0/8] x86, sched, mm: Speed up CPU hotplug on large systems
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "kees@kernel.org" <kees@kernel.org>, "rppt@kernel.org" <rppt@kernel.org>, 
	"juri.lelli@redhat.com" <juri.lelli@redhat.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>, 
	"tglx@kernel.org" <tglx@kernel.org>, "vschneid@redhat.com" <vschneid@redhat.com>, 
	"kprateek.nayak@amd.com" <kprateek.nayak@amd.com>, 
	"vincent.guittot@linaro.org" <vincent.guittot@linaro.org>, "bp@alien8.de" <bp@alien8.de>, 
	"jpoimboe@kernel.org" <jpoimboe@kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, 
	"david@kernel.org" <david@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"seanjc@google.com" <seanjc@google.com>, "ljs@kernel.org" <ljs@kernel.org>, 
	"zhangguopeng@kylinos.cn" <zhangguopeng@kylinos.cn>, 
	"dietmar.eggemann@arm.com" <dietmar.eggemann@arm.com>, "mhocko@suse.com" <mhocko@suse.com>, 
	"Gomes, Vinicius" <vinicius.gomes@intel.com>, "vbabka@kernel.org" <vbabka@kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"peterz@infradead.org" <peterz@infradead.org>, "surenb@google.com" <surenb@google.com>, 
	"hpa@zytor.com" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>, 
	"dmatlack@google.com" <dmatlack@google.com>, 
	"tim.c.chen@linux.intel.com" <tim.c.chen@linux.intel.com>, 
	"kexec@lists.infradead.org" <kexec@lists.infradead.org>, "pratyush@kernel.org" <pratyush@kernel.org>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "rostedt@goodmis.org" <rostedt@goodmis.org>, 
	"gmonaco@redhat.com" <gmonaco@redhat.com>, "jgross@suse.com" <jgross@suse.com>, 
	"mgorman@suse.de" <mgorman@suse.de>, "Graf, Alexander" <graf@amazon.com>, 
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>, "liam@infradead.org" <liam@infradead.org>, 
	"ridong.chen@linux.dev" <ridong.chen@linux.dev>, "blum@kernel.org" <blum@kernel.org>, 
	"longman@redhat.com" <longman@redhat.com>, "bsegall@google.com" <bsegall@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 19, 2026 at 2:22=E2=80=AFPM Luck, Tony <tony.luck@intel.com> wr=
ote:
>
> > Benchmark workload (mean of 10 runs per step):
> >
> >  # echo 1 > /sys/kernel/rcu_expedited
> >  # for i in {1..N}; do echo 0 > /sys/devices/system/cpu/cpu$i/online; d=
one
>
> Side question. Have you had issues with this step failing on large system=
s with "smart" I/O
> devices that support many interrupt vectors?
>
> Some validation folks inside Intel had some tests that looped taking all =
CPUs offline and
> bringing them back. They complained starting around Sapphire Rapids this =
their test
> would get down to just CPU 0 and CPU 1 and fail to take CPU 1 offline bec=
ause there
> were too many interrupts to fit into just a single CPUs available vectors=
.
>
> It was a while ago, so maybe something changed in interrupt code to handl=
e this.

Hi Tony,

I didn't encounter that issue while collecting the benchmark data.

For the Live Update work I'm currently doing, I leave 8 CPUs on the
host to perform kexec while the AP CPUs are removed from the
scheduler. In the future, I plan to leave only one host CPU and have
the remaining CPUs manage the VMs in Caretaker mode.

Best,
Pasha

>
> -Tony
>
>
>
