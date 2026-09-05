Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CEE72D9797;
	Sat,  5 Sep 2026 00:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788568930; cv=none; b=J42569u0z5vyyyvqxuswbhXClI9O8ncIFYuDa+gd4KoTaAdtg9wfKGP4SuSDAgqrCYCfYVe9LVZXysmyW7tBOeVD+zAt/AK1m3ZW6u8pp9UfFzdbqJ64E0Y43bB7wuN8nnG361ob6uCBZEXhfBzduNHhnGRpAsKs3DJU4TJRY9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788568930; c=relaxed/simple;
	bh=71PPz04tkf0AuITpJH18jFlEan9Se1xnoR3MazK7WKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jfYt/v6MkClNoPxgXT9QgVaV/geLzHQGkSktOFzSQ7+sJtVnxabScX1YdQ0IgNL6fXCnKBzVaQrfIexDpqByFIAsp4eLzcTWocOyDTz4C++4+K+n0vS09aIx5QN+dYE7401iSHafDv0zF9HS4f8ITceqqzaVEQgPmiVuUkkeFNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XQcIHMD1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XQcIHMD1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A03941F00A3D;
	Sat,  5 Sep 2026 00:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788568929;
	bh=9eF4S+ZPs/VCCxYBSVA4Wx58SRLtX8X6GyNUKQVmFVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XQcIHMD1aBp4ulFfQKdE+uF0T9mjaEzAlHsavMR2WMj3uWS+Cdb1RVFelsupiyXNQ
	 uijncxtMoNcsGpCzYuZg7GIDlD0NUKseJu1RBnRuRp9IBFpilaF6HfhBvnNQI6/F0x
	 qu5583RjkRxwFJ517D3Qgy5KUNPttqlgqKV0M/y8o22siCEiOsPSJs8Lhld50X+3E+
	 QhBHvdO46wx+iI8bngbrHScMu5lzV+g/SUL7dMl2me0u7Y6v5+SE8MLYFre2iLU4TW
	 YlI9sGuG9JHaVKMr5O5HmWCw94PW4Bq5JtyFIuxnyaOXrzIVWQ5xte7uBORJhlrlTx
	 Jy109tERoYWKg==
From: SJ Park <sj@kernel.org>
To: Hemanth Selam <hemanth.selam@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] memcg: fix typo "memroy" in comment
Date: Fri,  4 Sep 2026 17:42:01 -0700
Message-ID: <20260905004202.68515-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260904104254.16103-1-hemanth.selam@gmail.com>
References: 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri,  4 Sep 2026 16:12:53 +0530 Hemanth Selam <hemanth.selam@gmail.com> wrote:

> Correct "memroy" to "memory", reported by scripts/checkpatch.pl using the
> misspelling list in scripts/spelling.txt.  Only touches comments, no code
> changes.

Looks like a correct typo fix to me.  Mentioning of spelling.txt looks
unnecessary to me, but that's trivial.

> 
> Assisted-by: Cursor:claude-opus-5
> Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]
