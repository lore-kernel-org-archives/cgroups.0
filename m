Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794596637;
	b=uSefa4H4l1nD7hTP3tzOpYw6CgCIst2ekYE5FO4qYRrAOgQYjPfAVReFa3S8l4jpcybQ
	 kIWGPYD+iLnHpeYkHR7QRpPnzxHlLE+1RsdFMFaEhgBiKo4z7mEY5VrEkwDgDaSMc1flO
	 0z4jtvIafhYdjIzpSuhOq7y9rAeGY6AOLKSyQxrzf7q1IDapMaSZN4tJ+QM8vDy66gymb
	 Hqk5UPxIaFauYJRxmhRe7iHILOOebx1BL+ShSrlzzgOMHKAgs0DVtow8qu05+ey2gd4He
	 pXlVNrnhWSsv+DAbT3hdJsT32xOGX2++YYth5qwhoIa/MduVuV+gffJqI7dfPcRcxVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794596637;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=B8e5HKLQPjiewefcw3UmEbt8O+zGd5jVIMRqzWZmXx4=;
	b=IwJ372wmioqVWMnRKuw2Glhu9BtSCSJwVcWAZNqN8zjWC3EE/1O1bbzR6zPUATOqccey
	 dMdNVUWackMQHfQ7rW0Zc9mTZILxCDbDRENogTp//+jzOoVYcojc1NOb2Kh0yqZTV8/mY
	 8F7bcbYBA/LO98+SP4iIQAbohAqS1p7JSeyKmQvLAEQuDqGz+IuAGsp++S1lhwoCBv0jY
	 Pn+LRtwEQ1XAGkjE3Fh3J51XMBWM0vJzj9b3hTL6zd64cUt21ZZMnevJjZj1TW/kAUCDE
	 KOQDFx848oMu3BBxJkI3WYwGtOK2AqtA1sYSawXbhmqNcMU1vrVz+8FQ3pdRY5fClaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iDJt8bSH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C49A606A898;
	Fri, 13 Nov 2026 19:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iDJt8bSH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2DF81F000D2;
	Fri, 13 Nov 2026 19:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794596636;
	bh=B8e5HKLQPjiewefcw3UmEbt8O+zGd5jVIMRqzWZmXx4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=iDJt8bSHUb6GKzc8LQxtr0yPgf7vGMLxP8LULE4bwtP2F1dXmq+Q7n+jfvQyfHLT0
	 FGKYgYsWfn9d9ciUZOCKoxOOncQTCUWUp4+xrfaj+SDHrWgzldXoZ595FD10gvcO4h
	 l7b4ejSDRNaFkU70dlywxT0VF63spGbbA93bYIPj/LgTzHh8OCeu8lC4G8cd64fDrh
	 1YcDKAp55qYmBA6Xw8mtf0Wrg0zMXHa67zNIjCIDyVo90/zj9YJFU8cwCBcZg7jpLW
	 660tNf+xu0MA6RBOLvihpPNdTC6CvVtvho9fRcHVWhabriUhrHmgi4ouq4Lm3d9Q6y
	 WHZOTDKRch7wQ==
Date: Fri, 13 Nov 2026 09:03:55 -1000
Message-ID: <b377f4e3e10ae563378dba5df038311e@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Oliver Upton <oupton@kernel.org>, James Houghton <jthoughton@google.com>, Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>, cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] selftests/cgroup: Make the object directory an order-only prerequisite
In-Reply-To: <20261113150757.646085-1-fuad.tabba@linux.dev>
References: <20261113150757.646085-1-fuad.tabba@linux.dev>
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
Content-Transfer-Encoding: 7bit

Applied to cgroup/for-7.5.

Thanks.

--
tejun
