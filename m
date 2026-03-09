Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2016E38551E;
	Mon,  9 Mar 2026 09:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773049982; cv=none; b=WLdQlVpTkdjQGqx9wRR4thLjlPupiGgfG8hPZxPpopv+zuJXHI1QusQBCB1okbvJsVqWGa/QLivyMH4zgHAD+eT3IIINErx3w8pBb28n9GKU3KKv+7DTft7Inu4Qa5K34Iivz+fjRkQWcPhBlzoGi3IQCqx+hc3+Q28voJz89cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773049982; c=relaxed/simple;
	bh=PMIuKPsEvPXOB7oPgsM4Nr0xqxaEsQcqjc5S8SS+m8Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sQ4x08bwWNHl1jGw6iXkfgLsMtYwKXI6lSYOPHY00+BmC9WPTNXnrn08H4eoU890Yr9eri7UdIvMl8f5eVPmBRRMqYAJlV4KXFuMYoHFSzJsJbw42Prp+AugksuGXjcfC8jxw9VfVciXurBsyUvm9k6RfqrDz1TeGq5cUOm2GC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WmiafaaU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WmiafaaU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54B89C4CEF7;
	Mon,  9 Mar 2026 09:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773049981;
	bh=PMIuKPsEvPXOB7oPgsM4Nr0xqxaEsQcqjc5S8SS+m8Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WmiafaaUd3N0urhZWm8ej60bzApAWQpt38JX2BoGr8OV3tszUuCJojKJMQmYGdJ7W
	 V9ZbwFBsf3RvRRBvf64aM99RzGfnI6VWkyivf4ZCXOhHJrOyJT1wo6kpxeMJIK0Pmw
	 O7H3J/IumMBFvtMEh5bfxgrIpVQ0tPc7ggQzTNSnbh3/hzml5wwraMlQ7GFkUt6CMo
	 vPXRZ+fzEvf6PqDOraPeM+pWGxu0R/MO6kMV39rYN6HkXH3aaB5DTR8LjuqgabY7jh
	 cP8GCa9K2RzX+qioulCI1ELzbTJD/VWY0bFe5y0mj7qmsdOijRN+Sp8gAcUgJDz4IT
	 NWvu6F0HYsBaQ==
Message-ID: <cbd42744-31e1-439c-b0f0-0cad052d3d9b@kernel.org>
Date: Mon, 9 Mar 2026 10:52:55 +0100
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] Introduce QPW for per-cpu operations
To: Leonardo Bras <leobras.c@gmail.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, linux-mm@kvack.org,
 Johannes Weiner <hannes@cmpxchg.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>,
 Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>,
 Joonsoo Kim <iamjoonsoo.kim@lge.com>, Hyeonggon Yoo <42.hyeyoo@gmail.com>,
 Leonardo Bras <leobras@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
 Frederic Weisbecker <fweisbecker@suse.de>
References: <20260206143430.021026873@redhat.com> <aYs6Ju2G4bm6_tl2@tiehlicka>
 <aYxviLoWsrLqDU7o@tpad> <aYywl1hdBQP2_slo@tiehlicka>
 <aZDw6xI2izFDfuuu@WindFlash> <aZL45yORfkNvS9Rs@tiehlicka>
 <aZjY9h3XXMNY-Ytd@WindFlash> <aZwYmNuucBspCYhk@tiehlicka>
 <aaJDjmnfuo8AM6J9@WindFlash> <aaYpICV55B70U1I2@tpad>
 <aa20uDGqnmiqYJ1w@WindFlash>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
In-Reply-To: <aa20uDGqnmiqYJ1w@WindFlash>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/8/26 18:41, Leonardo Bras wrote:
> Hi Marcelo,
> 
> Great, hiding migrate_disable under the static branch is the best scenario.
> 
> I wonder why we spend 2 cycles on the static branches, though, should be 
> close to nothing unless the branch predictor is too busy already. Well, we 

AFAIK static branches are runtime patched to non-conditional jumps or nops,
so there's nothing left for the branch predictor to do. Or maybe I
misunderstand your comment.
It does however increase code footprint and thus instruction cache usage, so
maybe that's an effect of that.

> can always try to optimize in a different way.
> 
> Thanks for the effort on this!
> Leo
