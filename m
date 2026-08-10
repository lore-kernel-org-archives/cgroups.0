Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E551042BC4C;
	Mon, 10 Aug 2026 18:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786388206; cv=none; b=NTF/CE1YmD2ACKI0WJz3Hw/6quai80/TLhTJ+2lP3QCYZV6fYqbMcyWjrYIwCfcF/ns0/1hL2lvlBSpigPINPyciFnKo5v1YayYFYALrkkHPue+SH6OQtFUeuCtf40D7U4YoWHQ4+OZ5WlPSTVW8NK0uF/WurviSowEZiD1GiMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786388206; c=relaxed/simple;
	bh=4LV/mJR6TeGHuPRon/C2txUf8EHSmOTtmTLr6HUDSfc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M0tOsYRPRdEy8ILVvCQHAFEf36EObFpsMFha3B2z87MRjTEOM0hRUiAKbcag0vCFsX1i0lhjplPQ+YjzUlgYWbVNH52SSP+YtgzQLp5Z7WxENmj8E7jTUEykCFItx9Qg90KDbcSu+40/M9YkZkDW0TkL5xK4BBhdovJiW5xdGBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SITU7f0G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SITU7f0G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E3631F000E9;
	Mon, 10 Aug 2026 18:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786388204;
	bh=CrXS5cfcSX3rQcokSH2I1+pGA8otnhTdGTrve404Y8M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SITU7f0Ge0Xzjpdl40vHwNuuTD9ZOcPVZ9lA/isZ2Nbdc8siHDm00A+MFkL2Ixjv8
	 mLI3pAfYfnxFHTpU6lVYBUuWgKOFTsbGOkOxRLwqxNbh2Of57zTqSUG7WG9GCTSQHs
	 cQa1UeEWpUDJ79AV0e10v6ryOpFXPmSF9qLh6uaBL3xeP7PcovGX38HU3+fmZ4sVPz
	 orJWAO15/UUa2+3UqNiHxUX3s59N6bXfotzXLSi+xgvtcKhh9hRUXhSrxvN/AVsh9d
	 T4zuG5bb3E97rxPTtvmj6f8lfYK1il37HKIuaPlTg6a2uvg1clBaRFjBl0x/y0901q
	 tZgV0X7ceQ8cQ==
Date: Mon, 10 Aug 2026 08:56:43 -1000
From: Tejun Heo <tj@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: axboe@kernel.dk, cgroups@vger.kernel.org, josef@toxicpanda.com,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	shakeel.butt@linux.dev, hannes@cmpxchg.org, riel@surriel.com,
	kernel-team@meta.com
Subject: Re: [PATCH 3/3] block: skip blkcg walk in blk_cgroup_congested()
 when nothing throttled
Message-ID: <anoe61mtiBJL3ofn@slm.duckdns.org>
References: <20260806183742.946953-1-usama.arif@linux.dev>
 <20260806183742.946953-4-usama.arif@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806183742.946953-4-usama.arif@linux.dev>

Hello,

On Thu, Aug 06, 2026 at 11:37:20AM -0700, Usama Arif wrote:
> @@ -53,6 +53,9 @@ EXPORT_SYMBOL_GPL(blkcg_root);
>  struct cgroup_subsys_state * const blkcg_root_css = &blkcg_root.css;
>  EXPORT_SYMBOL_GPL(blkcg_root_css);
>  
> +/* number of blkcgs with a non-zero congestion_count */
> +atomic_t blkcg_congested_blkcgs __read_mostly = ATOMIC_INIT(0);

Maybe name it to clarify that this is a count. nr_ or _cnt or whatever.

> @@ -1350,6 +1353,16 @@ static void blkcg_css_free(struct cgroup_subsys_state *css)
>  	struct blkcg *blkcg = css_to_blkcg(css);
>  	int i;
>  
> +	/*
> +	 * Every blkg holds a reference on this css and drops any delay it
> +	 * still has from pd_free_fn(), so this is expected to be zero.  Should
> +	 * a policy ever leave one behind, drop it here rather than let it pin
> +	 * blkcg_congested_blkcgs and disable the fast path for the rest of the
> +	 * boot.  Nothing can race with us at this point.
> +	 */
> +	if (atomic_xchg(&blkcg->congestion_count, 0) > 0)
> +		atomic_dec(&blkcg_congested_blkcgs);

Maybe put WARN_ON_ONCE() on it?

> +static inline void blkcg_dec_congestion_count(struct blkcg *blkcg)
> +{
> +	if (atomic_dec_return(&blkcg->congestion_count) == 0)
> +		atomic_dec(&blkcg_congested_blkcgs);

atomic_dec_and_test() is minutely more efficient.

Thanks.

-- 
tejun
