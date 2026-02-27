Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 841C63921E6;
	Fri, 27 Feb 2026 10:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772188441; cv=none; b=Rjt92sDfj5LIpjpe9Ep8oU0lVaLf1NSZQfiIcAkUtMu6V8z3nxiMh8FdoWm3eM+tMUNUOLOaVqZiwj6HLaQ+kP2J+ZlQ/YstDkHzPGc4DlhQV4EruPbqV6RS4/cdgXlotWCbmi+G6ubBnN0vaa02pDM5EzwyCR6nqNVmsp2VeWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772188441; c=relaxed/simple;
	bh=+ayBYmh7mmQQ3NbrLvDC8YL1mQKXG9EINhxxptKroT0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BgC/HWm53mpJCnHNX8cYlmPPdybPw3AVuS+wKBGDSWvSSQpWGIXOBDpuo6gRmCS6Y9j5j3w0J5Ynb8vVkx8G0r+vDla1BhrQZFYpmH3MVNR5Vi9ShDAA9IoLgleGNG9XaYXQPtKMonn1dPWPp4nrkMTj+7VdJZRkc72ryueUvEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VnCzC+OA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VnCzC+OA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9638FC116C6;
	Fri, 27 Feb 2026 10:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772188441;
	bh=+ayBYmh7mmQQ3NbrLvDC8YL1mQKXG9EINhxxptKroT0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VnCzC+OAH52FwZdNVEbOgC510jy0zwQ71JzkGBmQjg/TwXW5zkb1hmEiEoyqsQbYj
	 gXmQvWHJu0Gfpxiw6ZMCT/ys0/ipZCIoes1UVenKKM2RIHz3LvucDZbyLA8ND/jePz
	 4HjyPXTKec2tnFHm8HvMGRnDEJZfFtIQP8kpsJTsHAiAGg/v35K1zXaZsAD8V7AhkT
	 AtJz3dPZgVZhmEdESTcX0b9KwsyweUv+VquDgWyEuGPWC9FiOKDG2fNf84YOvKMNXw
	 haQl0momLlzSmPg7nYYhtod5NO5QVegubZ4y54qCxMSQZaL4I8Rxnb13CEls4ERIlv
	 NaURPWY91XfAA==
Date: Fri, 27 Feb 2026 11:33:56 +0100
From: Christian Brauner <brauner@kernel.org>
To: Matt Bobrowski <mattbobrowski@google.com>
Cc: Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Tejun Heo <tj@kernel.org>, KP Singh <kpsingh@kernel.org>, 
	bpf@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Lennart Poettering <lennart@poettering.net>
Subject: Re: [PATCH 1/4] ns: add bpf hooks
Message-ID: <20260227-verallgemeinern-umgefahren-6f89a46cc30e@brauner>
References: <20260220-work-bpf-namespace-v1-0-866207db7b83@kernel.org>
 <20260220-work-bpf-namespace-v1-1-866207db7b83@kernel.org>
 <aZz70R4zeFajNUls@google.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aZz70R4zeFajNUls@google.com>

On Tue, Feb 24, 2026 at 01:16:01AM +0000, Matt Bobrowski wrote:
> On Fri, Feb 20, 2026 at 01:38:29AM +0100, Christian Brauner wrote:
> > Add the three namespace lifecycle hooks and make them available to bpf
> > lsm program types. This allows bpf to supervise namespace creation. I'm
> > in the process of adding various "universal truth" bpf programs to
> > systemd that will make use of this. This e.g., allows to lock in a
> > program into a given set of namespaces.
> > 
> > Signed-off-by: Christian Brauner <brauner@kernel.org>
> > ---
> >  include/linux/bpf_lsm.h | 21 +++++++++++++++++++++
> >  kernel/bpf/bpf_lsm.c    | 25 +++++++++++++++++++++++++
> >  kernel/nscommon.c       |  9 ++++++++-
> >  kernel/nsproxy.c        |  7 +++++++
> >  4 files changed, 61 insertions(+), 1 deletion(-)
> > 
> > diff --git a/include/linux/bpf_lsm.h b/include/linux/bpf_lsm.h
> > index 643809cc78c3..5ae438fdf567 100644
> > --- a/include/linux/bpf_lsm.h
> > +++ b/include/linux/bpf_lsm.h
> > @@ -12,6 +12,9 @@
> >  #include <linux/bpf_verifier.h>
> >  #include <linux/lsm_hooks.h>
> >  
> > +struct ns_common;
> > +struct nsset;
> > +
> >  #ifdef CONFIG_BPF_LSM
> >  
> >  #define LSM_HOOK(RET, DEFAULT, NAME, ...) \
> > @@ -48,6 +51,11 @@ void bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog, bpf_func_t *bpf_func)
> >  
> >  int bpf_lsm_get_retval_range(const struct bpf_prog *prog,
> >  			     struct bpf_retval_range *range);
> > +
> > +int bpf_lsm_namespace_alloc(struct ns_common *ns);
> > +void bpf_lsm_namespace_free(struct ns_common *ns);
> > +int bpf_lsm_namespace_install(struct nsset *nsset, struct ns_common *ns);
> > +
> >  int bpf_set_dentry_xattr_locked(struct dentry *dentry, const char *name__str,
> >  				const struct bpf_dynptr *value_p, int flags);
> >  int bpf_remove_dentry_xattr_locked(struct dentry *dentry, const char *name__str);
> > @@ -104,6 +112,19 @@ static inline bool bpf_lsm_has_d_inode_locked(const struct bpf_prog *prog)
> >  {
> >  	return false;
> >  }
> > +
> > +static inline int bpf_lsm_namespace_alloc(struct ns_common *ns)
> > +{
> > +	return 0;
> > +}
> > +static inline void bpf_lsm_namespace_free(struct ns_common *ns)
> > +{
> > +}
> > +static inline int bpf_lsm_namespace_install(struct nsset *nsset,
> > +					    struct ns_common *ns)
> > +{
> > +	return 0;
> > +}
> >  #endif /* CONFIG_BPF_LSM */
> >  
> >  #endif /* _LINUX_BPF_LSM_H */
> > diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
> > index 0c4a0c8e6f70..f6378db46220 100644
> > --- a/kernel/bpf/bpf_lsm.c
> > +++ b/kernel/bpf/bpf_lsm.c
> > @@ -30,10 +30,32 @@ __weak noinline RET bpf_lsm_##NAME(__VA_ARGS__)	\
> >  #include <linux/lsm_hook_defs.h>
> >  #undef LSM_HOOK
> >  
> > +__bpf_hook_start();
> > +
> > +__weak noinline int bpf_lsm_namespace_alloc(struct ns_common *ns)
> > +{
> > +	return 0;
> > +}
> > +
> > +__weak noinline void bpf_lsm_namespace_free(struct ns_common *ns)
> > +{
> > +}
> > +
> > +__weak noinline int bpf_lsm_namespace_install(struct nsset *nsset,
> > +					  struct ns_common *ns)
> > +{
> > +	return 0;
> > +}
> > +
> > +__bpf_hook_end();
> 
> Is the usage of __bpf_hook_start()/__bpf_hook_end() strictly necessary
> here? If so, why is that? My understanding was that they're only
> needed in situations where public function prototypes don't exist
> (e.g., BPF kfuncs).

I don't know. I just went by other sites that added bpf specific
functions. Seems like bpf specific functions I'm adding so I used the
hook annotation. If unneeded I happily drop it. I just need someone to
tell whether that's right and I can't infer from your "my understanding
[...]" phrasing whether that's an authoritative statement or an
expression of doubt.
