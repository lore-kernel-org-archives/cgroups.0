Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794416810;
	b=ro8Q5Vq/IBxJ+r5noGf6Y2ZvHkF83klyx+nSII8zCfK9JnrxqWj2FT8m9y0bk09HF98U
	 hhaPjkpjK9B/CDXaVj9q0zfq46oq4ZCHtuQHyZIQKgkK/t3F4Qadm3ayn+pRXwCeMSnBu
	 7RNefEJTJzWXfEQGJdinLiQXHSFz1BZ7F1C0b4WbU9aJIWSLMUBT9lhwCXD2aRNYdDDLw
	 egOHCtor1KTIUm6Mj1F5CkYWgUkOqGLVQowZCvIkA+tqQaY6PZFPJZhvtIhWnuQYVKfn0
	 rynhUIQzpt52ue3ACD/go7SIRt2JUEbl8to5lU7cOGZc/HQ3LqrQ6iSL3tdQYnXS2+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794416810;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=psC4NgKCtEYat/Uib4+IFSS0sQa8liAyXOKNZfMYvcA=;
	b=cyttACmQWq0wpNE2ifvhsmBgFRCYykaViyfTHBRGm/afbqgDK3MTxTObBJMBXugEfieZ
	 Y+C7lQ+eXo79jqD3R/SdxmbyNtxC1xwug2fk4rhGqQZVW+gyrcCnAfGL6uh8Dw9RhjnvT
	 BU5NTofR//gSYI+lxg3so42VWBo5sECbY/259ywa+mdPBKoLdfyRb0nJNbvjBIn0DFskB
	 mD+9zN6sodCJW1phteMmR6rLcEwFYqGl1bgyuTcfmI2oT+m/Wr9kv4HeZfIKVNIN0OUna
	 KI3SzcLuiM1bMzDSLsCT4xXiGSIESRZYcyZsAEiyh+DEyxoOIQfmxx1hVMkg3LfUkDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nOCHMD52;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57CFF606A887;
	Wed, 11 Nov 2026 17:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nOCHMD52
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA0D41F00A08;
	Wed, 11 Nov 2026 17:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794416809;
	bh=psC4NgKCtEYat/Uib4+IFSS0sQa8liAyXOKNZfMYvcA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=nOCHMD52PTkWaBWXOco/7GC5GSkWr5dTXghIenmzDBZh19fCMTFy2ZHEUY9hIvbDU
	 OLXTlyJWVqAv64LlaKwSMvZ/YEsK4Vwgpj7ZdtTOLC+2QR22mg7tPFjjuuyy0oep9J
	 60Pf8rktj6x4SoZ7W2I+fvGQPneRrU4fP2fjutv5AUuqW7TUaaO77Vc406gBxWB08X
	 XFcCQ0+2DWDKyK/oS2VbqDA5YkOU+7HULMVBurGtDtj8CJhjug/hPwlJ3Ubmat61vh
	 CjRIK7ZHLp/rDpngc2xYyL3icvgy5W5pFLwErK+hWNmb22aEROcPY5kTpFfFRq4XZ+
	 EckSWMk7FWECw==
Date: Wed, 11 Nov 2026 07:06:48 -1000
Message-ID: <d24cc4ed085decddac1a958ccff29872@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Kanishk Singh <kanishk2607@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/cgroup: Decode waitid results correctly in clone_reap
In-Reply-To: <CAC=pywoHKV1157BrUsew_E4zriGMx3Gh8B2o_rR24c1yfZ1V0w@mail.gmail.com>
References: <CAC=pywoHKV1157BrUsew_E4zriGMx3Gh8B2o_rR24c1yfZ1V0w@mail.gmail.com>
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

Applied to cgroup/for-7.5 with the Fixes tag dropped.

Thanks.

--
tejun
