Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C4643498B;
	Mon, 21 Sep 2026 17:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790010694; cv=none; b=GdOngtjSHSneqAoo9X2zjxY4MffXcciaPbSV9657nEQbdqEywfS+Sgfb/7/bnrJCJRsnsm7FYCyVkaGSNQdlYROrQF18vq1EXDJ7IJ7cZJqUJoKSHhSyM628uW7Onh7X+6p1t6WCA20TPi/ZjxPum2fD43A/o6nUbewp0flQJ34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790010694; c=relaxed/simple;
	bh=uR7wV36xAa8iPqPouAh4nJajwisvFjBFYaA5qZKz864=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=ua834Ot/BsJ2ZCEdydeAFYk6z6DeYg2hw4VRBe9QMZm4MdJQxz0Sgqx1mGlG1+aA/h1fGJcufG7vFrksoSd+Ljv8sQzRjFg/MdIFXOhd5sVV7pz02Fq6l6cGYHpffiN1wz1zZCjZb+5Ia8Bna6EkshdLoAVCoSgGVLUDhw/+/28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CkjygLQN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CkjygLQN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B61311F000FF;
	Mon, 21 Sep 2026 17:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790010693;
	bh=uR7wV36xAa8iPqPouAh4nJajwisvFjBFYaA5qZKz864=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=CkjygLQNUFgF8fc+1lUNhYGIHTCD69CrZhTdw5fZTJ5kkDNCX5DoZMpxzRSxItiwu
	 RsjhTgGP1TbTa8hJGl3rVyTxwFOzV7CtgwoHkpV9p0nAgkGAsTNL1kNNJdJ4EgNGsE
	 KBGMJeSDFu5skqosMzMSUGA/VJY2smsy2H8Vb92919QINuN8sU2f4WRZz6VT/CWz8r
	 t3eouHmfSfmEew2whWQxW2t/TF9aLsy1I8N1pWnfgfpT0gRYLoCAfA8Om5d9ZynRby
	 1Z2uoEdpL+9oXq3bKPW3HQpWkft+Ap/9oTwGk0lJZPdqKs+EdXvgFa87mQeJYtxGwk
	 pQbBT0f5Sz6OA==
Date: Mon, 21 Sep 2026 07:11:31 -1000
Message-ID: <bf596586f199ae64e36ae644b380c505@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: "Peng Fan (OSS)" <peng.fan@oss.nxp.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>,
 linux-kernel@vger.kernel.org, Peng Fan <peng.fan@nxp.com>,
 cgroups@vger.kernel.org
Subject: Re: [PATCH] cgroup: use assign_bit() where applicable
In-Reply-To: <20260920022738.3145820-1-peng.fan@oss.nxp.com>
References: <20260920022738.3145820-1-peng.fan@oss.nxp.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

Applied to cgroup/for-7.4.

Thanks.

--
tejun
