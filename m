Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=178.63.66.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793995176;
	b=QU/1PkWmQj+0TOvJK1XRVCyctTRII06byVoPygsck1MYRQf5ghfw5i9b5iSlHXvN0t0m
	 t+NCdTfN0RrdnwgnFjejomSPd4Lz7vQnLTBRdROCRHnRtCi3bTthjKmJ1p0zoJZ+ezehT
	 TrOqHbEDYLPpO747fj7OO1bvwpP9aJSHzhuSJy/9jO2SKyFzV+DIxXViLm+BOjtryre7L
	 DYiXkO16FNAlsjR6wf966acYrIXBgYwIwx2myZfmffHsRffYvWmLy5GT/Z/bjwJsx2T3s
	 GoWdEV2P1IxvxGLkKlKk6vI0tXFzKR19SIREV1UAJKtCZVkkeAO+979llTqiO81SCnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793995176;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=4JJO7J4fojnA0nt5hwOEl9UDSFikUampjKz664dNgaI=;
	b=UxnQ84L8ykdngxvojz6bpdDPZBcvEsOUcuYs6V8KAlg6/05+Q3a8uJQ6HUxutiGevRXg
	 I9Gurp536qurXsqKQ7UNZKYRCFm8mfhGTAbNyTpBZxlt7zQzPIR0vkAlePJd58Nk3v8PT
	 iGIOk18LL55kD3jaSD8kSNlpQFBNmXVugofDcYEnajulfWdh+G5yboLx4fgMMQUPcxRa+
	 wU+y9i6gGs5SCO3Y1eHh/shT0+rkHCMOdHwL8LckWqijxqmFwzVPl4JyNmsttJRtq+TSp
	 Y91av6Xqotm7R3s0f15DVn3IQjf7u1McZhFNNOxcl20t/8HWLe4VHibHnE1BpcilsHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=hallyn.com;
	spf=pass smtp.mailfrom=hallyn.com;
	dkim=pass header.d=hallyn.com header.i=@hallyn.com header.a=rsa-sha256 header.s=mail header.b=Opz9o4VQ;
	arc=none smtp.remote-ip=178.63.66.53
Received: from mail.hallyn.com (mail.hallyn.com [178.63.66.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92459606A326;
	Fri,  6 Nov 2026 19:59:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 92459606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hallyn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hallyn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=hallyn.com header.i=@hallyn.com header.a=rsa-sha256 header.s=mail header.b=Opz9o4VQ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=hallyn.com; s=mail;
	t=1793995173; bh=I8hBdflsjy5ULST78omV7Oaz6W+NqRtKI6XBIEd0n60=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Opz9o4VQjwN9tzX/hO5eSaQ5FQr2WLZl2g1ulAKlt/I2IxmzJ07EHL9LiEfJOVcZ1
	 cx+7z1Uy5uM+BDh9hDXSmu4+YnsGU3op5jSCjUG33hSaM+zPGOjky5ElfFMhbwHAT1
	 13EStbhliD7a6DbxEWKx0jLosOxuuYIn/Huix4qegeXUbaoah8N3m625DbjOYsK+4f
	 7JNeWuVf9y2lKTxVFGvq2lheqSxd7h16n+LxptqmB8cjs41rJd9N/v+1Wiv0Up6Dmz
	 pIMe67tgdd44TRJhG2FM9jstawe6mBUAFw5k4oHUGNTZOPLyKwPUmef05sBb2tl67/
	 +C8idkqAnfGOQ==
Received: by mail.hallyn.com (Postfix, from userid 1001)
	id 952DC8B5; Fri,  6 Nov 2026 13:59:33 -0600 (CST)
Date: Fri, 6 Nov 2026 13:59:33 -0600
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Aaron Tomlin <atomlin@atomlin.com>
Cc: tsbogend@alpha.franken.de, paul@paul-moore.com, jmorris@namei.org,
	mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
	vincent.guittot@linaro.org, stephen.smalley.work@gmail.com,
	casey@schaufler-ca.com, longman@redhat.com, tj@kernel.org,
	hannes@cmpxchg.org, mkoutny@suse.com, chenridong@huaweicloud.com,
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
	mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com,
	omosnace@redhat.com, kees@kernel.org, neelx@suse.com, sean@ashe.io,
	chjohnst@gmail.com, steve@abita.co, mproche@gmail.com,
	nick.lange@gmail.com, cgroups@vger.kernel.org,
	linux-mips@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] security: Expand task_setscheduler LSM hook
Message-ID: <au4xpT1D8WzBxdvY@hallyn.com>
References: <20261105172210.76706-1-atomlin@atomlin.com>
 <au4ovp/Ghd25rtfZ@hallyn.com>
 <kn57okulm7cmodzdzvzqqswzafu3vopsatfcsptyrz5ztknx4w@ngwh6si3zgpo>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <kn57okulm7cmodzdzvzqqswzafu3vopsatfcsptyrz5ztknx4w@ngwh6si3zgpo>

On Fri, Nov 06, 2026 at 02:50:34PM -0500, Aaron Tomlin wrote:
> On Fri, Nov 06, 2026 at 01:21:34PM -0600, Serge E. Hallyn wrote:
> > > This change updates all in-tree security modules (capabilities, SELinux,
> > > and Smack) to accommodate the new parameters mechanically, while
> > > providing LSMs with the necessary context to enforce strict scheduling
> > > and affinity policies.
> > > 
> > > Reviewed-by: Casey Schaufler <casey@schaufler-ca.com>
> > 
> > This seems misleading - Casey explicitly said "for the smack bits".  This
> > makes it seem like he reviewed and approved of the whole set.
> 
> Hi Serge,
> 
> Apologies for that, it was not my intention to misrepresent the scope of
> Casey's review. The qualifier line was dropped when collecting the trailer.
> I will update the tag in the next revision to explicitly scope it:
> 
>     Reviewed-by: Casey Schaufler <casey@schaufler-ca.com> # Smack
> 
> > I see no issues with the commoncap.c and security.c changes, but as
> > Paul said two versions ago in
> > https://lore.kernel.org/lkml/CAHC9VhSROg6RGUN4_ZVBoEwYjRnKvyjnkbx2D88c09KiTgY3KQ@mail.gmail.com/
> > nothing appaers to be using these.  Where is the user?
> 
> The intended consumer is the BPF LSM (via the generated
> bpf_lsm_task_setscheduler() hook and the __nullable BTF annotations in

Ah, I see, thanks.

> include/linux/lsm_hook_defs.h). As discussed with Peter and Paul in the v3
> thread [1], when sched_setaffinity() is called, the cpuset controller
> silently intersects and truncates the requested mask without surfacing the
> original request, and seccomp cannot safely dereference the __user cpumask
> or sched_attr pointers without TOCTOU races. Exposing the copied-in
> sched_attr and cpumask to task_setscheduler allows BPF LSM programs to
> audit or mediate the actual userspace request before it is sanitised or
> applied.
> 
> In my reply to Paul on v3 [1], I mentioned that once the MIPS prerequisite
> landed, I would include a concrete in-tree demonstration alongside the hook
> expansion, which I neglected to include in v4 and v5.
> 
> Would adding a BPF LSM selftest (under tools/testing/selftests/bpf/) that
> attaches to lsm/task_setscheduler and exercises both the sched_attr and
> cpumask parameters (including NULL and non-NULL paths) be sufficient as an
> in-tree user/test?

Self-tests are good :)

> [1]: https://lore.kernel.org/lkml/ozsngetxq44lahategdi43sqrwdnpotsrebssczymqtkbh7snl@u6ytkznmpne5/
> 
> Kind regards,
> -- 
> Aaron Tomlin
