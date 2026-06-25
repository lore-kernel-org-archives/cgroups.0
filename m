Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B57D31AAAA;
	Thu, 25 Jun 2026 13:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.97.179.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782393919; cv=none; b=iMUkvS9smgXzwckGnDzf4JNxJNtIB/OA0ST2o7sziNHvvFUnNna0DGbq3bxDlAfh7oyU8SwM3aOd/0Vz4iYA9bLajOw6MkQ070nczJVP6F3WNUrpjyJmX7RRKW10iIjMf/RG/d/8pioJ2QGEafSJjT0pyXpEdYx6bxoL+aQcmnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782393919; c=relaxed/simple;
	bh=cDRm9o+e1DCCdszZq67gYsG5H2t3Q6tznqzo59jSHew=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s0a5voz+sUauWpR+LxhgarEZoOpCBFnHTJO2ix7XN5IXoE2ugQWn63JOvgjAtaDtSwpHn/hKjP89l/Qk76DZZDxX9S8ThY1iAUqDm1X8TpCbDc6wdNCzCTm1zL0aCLBf3T++CH0lWbiCMlhcYaBpktES5oFL+og0WgOYcKozrY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=WeysAnzO; arc=none smtp.client-ip=213.97.179.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="WeysAnzO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ZhSTsKEqP6hhtF0Rymr3DME6a07dkDUYrzylnv1XxG8=; b=WeysAnzOduioc9tUdPr9SEjsBh
	osUbX3DUqMcCAWzhJjeG5xFcNAVx8p9RI2X92EIdRBCgOfAoO4oBA9s4CkbL2YQm8bwGVjevivOuf
	RQD2BX+5lF0iI5yxAzQVO8bshTYrPSD10ssSQ0eeTeVoSxo5q4rk3c85UArdJkFxeAV2v1/L9cAH1
	8Hrx+Et3sR6MQUPFuAKsBS7iKDRGUN9ymkwSH5EWhgUB3bzYL3Bo/WsRhEv4G/apKUcLnCxDJJFE8
	bjLmxOFL/nCYI8Z5WcpF7DIHq0+Sqssz1i2hxyE8RVIEk9A8bLbsncgPgnsrUm3rKyy5IK69ydYI2
	PolOxVjA==;
Received: from 179-125-64-254-dinamico.pombonet.net.br ([179.125.64.254] helo=quatroqueijos.cascardo.eti.br)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1wck4j-00548a-Ap; Thu, 25 Jun 2026 15:25:02 +0200
Date: Thu, 25 Jun 2026 10:22:02 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: Tejun Heo <tj@kernel.org>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	intel-xe@lists.freedesktop.org, Natalie Vock <natalie.vock@gmx.de>,
	Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org,
	Huang Rui <ray.huang@amd.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Simona Vetter <simona@ffwll.ch>, David Airlie <airlied@gmail.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 0/6] [PATCH v6 0/6] Add reclaim to the dmem cgroup
 controller
Message-ID: <aj0rembs3CGy0ZMX@quatroqueijos.cascardo.eti.br>
References: <20260611173301.17473-1-thomas.hellstrom@linux.intel.com>
 <ajBJU-Jp2QVy14qt@slm.duckdns.org>
 <ajBLAsNoKesXmFcs@slm.duckdns.org>
 <ajlUPmaMsa2gxOLg@quatroqueijos.cascardo.eti.br>
 <ajzxLABtnWym81Dp@localhost.localdomain>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ajzxLABtnWym81Dp@localhost.localdomain>

On Thu, Jun 25, 2026 at 11:19:19AM +0200, Michal Koutný wrote:
> On Mon, Jun 22, 2026 at 12:26:54PM -0300, Thadeu Lima de Souza Cascardo <cascardo@igalia.com> wrote:
> > As far as I understood the patchset, it doesn't fail the write if it fails
> > to reclaim. It sets the new max, then, if the write is blocking, starts
> > reclaim and eventually returns after multiple attempts. But it still
> > returns success.
> > 
> > So I believe this is behaving as you would expect.
> 
> I was alarmed by the EBUSY mention similarly to Tejun but then I
> couldn't find it in pre-patch (840ef6c78e6a2) nor in patched (v5) code.
> Please make sure the EBUSY return behavior is not introduced
> (essentially match memory.max behavior) and that the accompanying
> message refers up to date code ;-)
> 
> Michal

I think this is a reference to the fact that right now writing to dmem.max
calls page_counter_set_max, which will return -EBUSY and fail to change the
max value. It is just that we are not returning that error today to
userspace (a fix I have submitted back in April).

So, this patchset by Thomas is setting max, and, then, if it is a blocking
write, tries to evict on a best-effort basis, and returns success after a
few attempts, still setting max to the written value.

Cascardo.
