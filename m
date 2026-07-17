Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A8B39A7FD;
	Fri, 17 Jul 2026 18:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784314431; cv=none; b=tQM5vCIgFmMIpmZCT7qbT2IC64R+/kKtPmK7kXskJPONOae6mSnAGEErkT+AZbKZo42xKl4h9fxLjriymb1ztARR0WYpgymAdX/2vCkFTnRFegJstgP8nqEpZN6+vyWZyhJnPkQH6NzVaKa5+WJZL6EZjgN1W19553e2gINTK+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784314431; c=relaxed/simple;
	bh=/t/xHQhZRV+2cS20X3XzU3GSDdE7WD4GMFCsqSof8pE=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=OtYHZAPggMGogUNToh5Nh/i3qIJbKCBNxfvy5K/+Mox+pL1z0jOjiMc7rH4s2Rx5J+j7dd6NlCLr7WwXzeIag/3KEfruC/+ISpSjdv65hRRb84eBIw3j2qkqsgx6Ea11iu3jgH4nrQEhdIeK2MAoP/qHCEI3+mo42Pr/V6YzWVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sEIVnUy/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sEIVnUy/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 794E71F00A3D;
	Fri, 17 Jul 2026 18:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784314430;
	bh=EA5rWpqXq3j+AjVoHduxTotL9GnFGdK6qs7h9uZHdxY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=sEIVnUy/f4Ud1WPRQdcgob1uu67veaxZHP9/36k8ek7nc9E/da7QRRXfS2zvT4wJ5
	 BF4AFZRLjmWpUuQEqlm3k5aqeW9sxYY1jUiLaIQ1r6qnzPG/fp1wOO7hzKUTnsJwzj
	 3PT3PtkNrE3yBDCuYXjTQASpmKMUrX4T0z1DFsZs=
Date: Fri, 17 Jul 2026 11:53:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>, Vlastimil Babka
 <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan
 <ziy@nvidia.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark
 Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>,
 Michal =?ISO-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, David Hildenbrand
 <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v3 2/4] cgroup/cpuset: update some comments about the
 page allocator
Message-Id: <20260717115348.9ff2498eafb8ea256a0cb504@linux-foundation.org>
In-Reply-To: <alplxFeazzK_Ziie@slm.duckdns.org>
References: <20260715-spin-trylock-followup-v3-0-fc4d246f705d@google.com>
	<20260715-spin-trylock-followup-v3-2-fc4d246f705d@google.com>
	<7f4e784ee2bbbc23b4b97913e144c0d9@kernel.org>
	<alplxFeazzK_Ziie@slm.duckdns.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 17 Jul 2026 07:26:28 -1000 Tejun Heo <tj@kernel.org> wrote:

> On Fri, Jul 17, 2026 at 07:23:58AM -1000, Tejun Heo wrote:
> > Hello,
> > 
> > Applied this one to cgroup/for-7.3 with Vlastimil's reviewed-by and
> > Waiman's ack added. Please drop it from the mm series.
> 
> Never mind. I'll drop it from mine. Sorry about the noise.

Thanks.  Plucking one patch from a 4-patch series is awkward.  Better to
retain this in mm.git with your ack(?).
