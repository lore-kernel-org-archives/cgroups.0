From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup/cpuset: Make child cpusets restrict parents on v1
 hierarchy
Date: Wed, 12 Jan 2022 11:25:33 -1000
Message-ID: <Yd9HTVxEPo2/zfou@slm.duckdns.org>
References: <8d73dc26-74e1-d763-d897-6e03cdac3c8c@redhat.com>
 <20211217154854.41409-1-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=71MHWWgwv/fcd6sVQlX/nQYgJbOKyivyKZ2pLN/ooAE=;
        b=MBKN0ogjzTfVJcRRMglHt5ESyQHxLRwHCERWBzWPgi83VsoxTi/Fbn8BYq/uobfLzZ
         gHZp+dt9q700lzX2CllbNPEzFxC2mi2HCC6jQZGf3GM+tSFkr4RxazZlKiX52oxuYdHO
         u27qqIDERnsUEtWROk2gV3xo3MCQPV+p61qlPOqHxVW5IZ0o67fe93e8aiV9efjo2z0R
         EhHLVlGg4Pa0/P3so+qZE3kbaDSJMsts+HEvdWoUH07QFmfRW7WMEN4HtpMsW/xHTIf0
         m+MHVNTyDXpXyh2xH5gY7ShdMbrOlFuqW1s45u/xNjJ+33GeSfqzTgTkSRD1RyUDdC6Q
         hcsQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20211217154854.41409-1-mkoutny@suse.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: longman@redhat.com, akpm@linux-foundation.org, cgroups@vger.kernel.org, corbet@lwn.net, frederic@kernel.org, guro@fb.com, hannes@cmpxchg.org, juri.lelli@redhat.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, lizefan.x@bytedance.com, mtosatti@redhat.com, pauld@redhat.com, peterz@infradead.org, shuah@kernel.org

On Fri, Dec 17, 2021 at 04:48:54PM +0100, Michal Koutn=FD wrote:
> The commit 1f1562fcd04a ("cgroup/cpuset: Don't let child cpusets
> restrict parent in default hierarchy") inteded to relax the check only
> on the default hierarchy (or v2 mode) but it dropped the check in v1
> too.
>=20
> This patch returns and separates the legacy-only validations so that
> they can be considered only in the v1 mode, which should enforce the old
> constraints for the sake of compatibility.
>=20
> Fixes: 1f1562fcd04a ("cgroup/cpuset: Don't let child cpusets restrict par=
ent in default hierarchy")
> Suggested-by: Waiman Long <longman@redhat.com>
> Signed-off-by: Michal Koutn=FD <mkoutny@suse.com>

Applied to cgroup/for-5.17-fixes.

Thanks.

--=20
tejun
