Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3C13F1AC9;
	Tue, 19 May 2026 11:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779189777; cv=none; b=fnHd16CWhuxcTjDr1QSTBwtvaFCy5FXFWe6nz/Xi0fGzaTwW4WgGMkhrBvA8WmVL6iWat7BzG8puN8isB6KuGueXjaKy8gEZyl5+Jb4CE6bEsQuwMoNC0bS8OSKMS3jAJfKZpihmTD0HuImNBuJ7Q+yZnuYiUk7OG88cxlBRjkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779189777; c=relaxed/simple;
	bh=gc360qGXUrPfTfpneVVNX9VHgZq+mPudQxnSBXz8kUA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AwGnihZnuWlyDsBQ0Z//dBlEDl5F4M57rxCsZi0CqppNrlg23/+CcoXIAkxKfrSrpsMD8nCJOQpa/tW7Dmec/WmnlCjaf4mJPuKAwMfFAs9jUvNZF/qVAwnG/w1XsO5DU/4cQ2t1tD6u9/S2XVuJ91NKRcPVxjcq98zKGErZzNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V0rpKCMR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V0rpKCMR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54AC7C2BCC7;
	Tue, 19 May 2026 11:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779189776;
	bh=gc360qGXUrPfTfpneVVNX9VHgZq+mPudQxnSBXz8kUA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=V0rpKCMREYqSY21J8h1NTof9rp8/fytmRhaENLUJptlBlCG+6yG3u29xYQOZZnw5t
	 V2CoRKLu5neRiBwYRyoIeDRfMlM9iRKifYpnEO7nTyIVDg2gUfXJQA9ctdOWRhG1b6
	 cAev9QAiJCaX4LDe2qWc6jtdT0vHZaUEZ47in2LKXXqegQzCXuls78ZRikcFmdkHyL
	 m7+K9JK0wlpfmcUV4gzMOB0eg2DnHRrgn7W72FXdTwy17/EhZZSVBMTmz7HftXBMdR
	 etpVgo0bJk7Rk5CyLtxGh9ssfJCuSqeJz5I3VDbotYh5RF/KSwNcA4xW3dkScOndxJ
	 JBRcM25I2c37g==
Message-ID: <32387576-691d-44b7-a5de-c211046e376a@kernel.org>
Date: Tue, 19 May 2026 20:22:52 +0900
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: memcontrol: propagate NMI slab stats to memcg vmstats
To: Alexandre Ghiti <alex@ghiti.fr>, Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, stable@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260518082830.599102-1-alex@ghiti.fr>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260518082830.599102-1-alex@ghiti.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/18/26 5:28 PM, Alexandre Ghiti wrote:
> flush_nmi_stats() drains per-node NMI slab atomics into the per-node
> lruvec_stats, but does not propagate them to the memcg-level vmstats.
> 
> For non NMI case, account_slab_nmi_safe() calls mod_memcg_lruvec_state()
> which updates both per-node lruvec_stats and memcg-level vmstats, so
> flush_nmi_stats() needs to flush to per-node lruvec_stats as well as
> memcg-level vmstats.
> 
> So fix this by flushing to the memcg-level vmstats for NMI too.
> 
> Fixes: 940b01fc8dc1 ("memcg: nmi safe memcg stats for specific archs")
> Cc: stable@vger.kernel.org
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon
