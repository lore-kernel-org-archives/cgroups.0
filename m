From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [RFC 0/2] cgroup: New misc cgroup controller
Date: Tue, 23 Feb 2021 19:24:33 +0100
Message-ID: <YDVIYQhZ6ArGsr3n@blackbook>
References: <20210218195549.1696769-1-vipinsh@google.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="wVuyn8fuAPNhRfeX"
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1614104677; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XbjS8vUMSKt77z3E7DlvrJ60e+qrAIbjzGDe/XybRK8=;
        b=WV9e18U9LOLZfXySyD6DPWQ9kGd89w1u7ieLGsL1hwOeS9bYjIYC+DSsJUtANPV0TjZU9M
        +9r5xp23/mpAPOBjX50BU5akyn/t/Ayowi4aRfL14Hy9dC3BbUeJXjTSyxB6TLbWPG3wfA
        xEpW7VGe2tt/oXGuKvCTZjNt3yxwcBM=
Content-Disposition: inline
In-Reply-To: <20210218195549.1696769-1-vipinsh@google.com>
List-ID: <cgroups.vger.kernel.org>
To: Vipin Sharma <vipinsh@google.com>
Cc: tj@kernel.org, thomas.lendacky@amd.com, brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com, pbonzini@redhat.com, hannes@cmpxchg.org, frankja@linux.ibm.com, borntraeger@de.ibm.com, corbet@lwn.net, seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, gingell@google.com, rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org


--wVuyn8fuAPNhRfeX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello.

On Thu, Feb 18, 2021 at 11:55:47AM -0800, Vipin Sharma <vipinsh@google.com> wrote:
> This patch is creating a new misc cgroup controller for allocation and
> tracking of resources which are not abstract like other cgroup
> controllers.
Please don't refer to this as "allocation" anywhere, that has a specific
meaning (see Resource Distribution Models in
Documentation/admin-gruide/cgroup-v2.rst).

> This controller was initially proposed as encryption_id but after
> the feedbacks, it is now changed to misc cgroup.
> https://lore.kernel.org/lkml/20210108012846.4134815-2-vipinsh@google.com/
Interesting generalization. I wonder what else could fit under this as
well. (It resembles pids controller on the cover.)

> Please provide any feedback for this RFC or if it is good for
> merging then I can send a patch for merging.
A new controller is added exposed with v1 attributes. I'm not convinced
it is desirable to change the frozen v1 controllers' API? (And therefore
promote it as well.)

Beware, bikeshedding. The name is very non-descriptive, potentially
suggesting catch-all semantics. It'd deserve a further thought. My idea
would be limit(s) or counter controller.


My few cents here (and some more in reply to the patch),
Michal

--wVuyn8fuAPNhRfeX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEEoQaUCWq8F2Id1tNia1+riC5qSgFAmA1SF0ACgkQia1+riC5
qSjyug/+JnqIiM/q5Fq9IapQYcrjFfqbXe/ULrbJurWNM7N1IY/PQQd6XKqXv+GH
bjV7UZCa8Rr+TWaVx4/dw7HycGzwCpxVGZ3afm1R2KujhucRR6x3Jfu3al08HASh
tyALCpp7s7bKb1b3ehnq6vEonsEinSbiXYHl4iWXN8EL2Kl/bQNOq1qqshLUMNGL
1WXuvfM0seMziFSh/BogVLx77yzInWj1Q4nE19yWYWh2go+CcZjTSAFc2uJn0fWn
DIMvt4QaXNEOrr1nyLqSJWR3WVl8OGTx7jec9u9IGmLDT1cmXLM7cEpSuRxEW8KQ
A7Dd2NBQ0foZsUFC8N+mWqpDMKAUP9ZG4KIplBubWJittkd4MIcpoBReO6DVdHzM
Zc6IdpCON8+kYVGaHSswOkx30BdIEeTf8wmIywkkDRQcrHS6fYO8QqqThzsfcWiD
uWIvZMDqu9X4LqPctqCkr/Aw8goAW764Q35xABYonDIUhJfZfcdR7sRFZrIdl3xk
+UmPWynRCXJ5/XIj4Trm4H/AvwOR2zX8NywuoGF9r8tfHcBR8gqwtMyg8un4eEcG
jroaVCayT9ZJI+49XV7qvZNaF+yg8GL0EDimIl7r0m5vi157AGxWhH7jfOFlbN6Q
JFP5/0x+ZIssTiTuytqRC+cE+j3Jl1LVZ+MZjz68btbTckO83Y8=
=WGjH
-----END PGP SIGNATURE-----

--wVuyn8fuAPNhRfeX--
