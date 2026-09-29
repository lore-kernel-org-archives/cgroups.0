Received: from o1.ptr9745.em.honeycomb.io (o1.ptr9745.em.honeycomb.io [149.72.141.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F90E313531
	for <cgroups@vger.kernel.org>; Tue, 29 Sep 2026 01:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=149.72.141.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790646409; cv=none; b=Fy2M5ZLZuGNl4wN5UjvhEVfuSeIB4z9N2qYD+N3xEMwHiuMH+2QIFbSelXH9dY2WV2AImKi1cH5YwHnPId1hd5zdrFCW0ZgcWbcKHI1+efzjjqCXm8fsWC8WU77kZ7zTt5Gbh17LY/XdjKKTKaD5aLeN+5WXCRcP4kAGPdGRzTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790646409; c=relaxed/simple;
	bh=BY+ZR+59ph0ptdNOUBfhhegIGdvdWVl+x1slBg31AE8=;
	h=From:Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:
	 To:Cc:Content-Type; b=ifDk+aBjrE2OlfhROpH4OxALOVsoVc4Ulhwzjh8fcv9UBaunZ3LlPy5yWXArSo+Xy+zDapGz14Ni6uZi0Ppgw9JQ2Ud3hYrfnlcLR/hoCegWuisPy6xfATVLt9wHSLhx4pe5knyHSTVYHUo6gwGgK0abHbxEz1F1FI93Dj4hwkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=honeycomb.io; spf=pass smtp.mailfrom=em.honeycomb.io; dkim=pass (2048-bit key) header.d=honeycomb.io header.i=@honeycomb.io header.b=p2CzMLOt; arc=none smtp.client-ip=149.72.141.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=honeycomb.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=em.honeycomb.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=honeycomb.io header.i=@honeycomb.io header.b="p2CzMLOt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=honeycomb.io;
	h=from:subject:date:in-reply-to:references:mime-version:to:cc:
	content-type:content-transfer-encoding:cc:content-type:date:from:subject:to;
	s=s1; t=1790646406;
	bh=mjr4nqeM7n36WuKKf5YXVh4Uzg4b73TbpTuDVtR5MvA=;
	b=p2CzMLOtjdg/qpxtKmM7R78US9WK0lqk4B6w77BnfxnpvQPI6PHJFP/yFMH3fzOtmjz3
	r+v2AYeujSWtCGbv4+QZiZgCTxrJSZvFw8B4Fl+NmTpzCcNgIY8hZ2uxFU6wReRb7Xn5Tn
	s/u0jL2i3JSfUyts2CQsrLqpiqVOjCLkkrMh1r/9c5ifQhXmhhHhkJtZiC8cwW7wVNB0On
	Oav7vbeo+jhq9FDTOzqCLiIwKNLprPjMuzVN/9D5XAXE/S/FT7l2yabA8TAmrLGulVLCi1
	96UV7Umv67n2ZCdbOFw4Z6IiWKQjmy3KY/jCjzUZLV0ajjl/k54t7C3Q5tnCIu2g==
Received: by recvd-7fcdd7bc5-f26mq with SMTP id recvd-7fcdd7bc5-f26mq-1-6ABB1886-1B
	2026-09-29 01:46:46.322011859 +0000 UTC m=+367138.101351504
Received: from daisy.dens.ffj.family (unknown)
	by geopod-ismtpd-9 (SG)
	with ESMTP
	id MYZBB6JWSTelCpJw5DSpOg
	Tue, 29 Sep 2026 01:46:46.242 +0000 (UTC)
From: Liz Fong-Jones <lizf@honeycomb.io>
Subject: Re: [PATCH v2] writeback: let foreign flushes reach dying cgwbs
Date: Tue, 29 Sep 2026 01:46:46 +0000 (UTC)
Message-ID: <20260929014645.1573059-1-lizf@honeycomb.io>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260928165612.dca65d7bacfc726508ad7d97@linux-foundation.org>
References: <20260928-wb-dying-cgwb-flush-v2-1-56b54cda74f2@honeycomb.io> <20260928165612.dca65d7bacfc726508ad7d97@linux-foundation.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SG-EID: 
 =?us-ascii?Q?u001=2ECuH7N2XAoeMR1zrzr=2F6NZrhli2vbKPOHff5fJuZuba6ZIE8QPyIf9mn4Y?=
 =?us-ascii?Q?ezqeFFjUkh=2FeROy4LtnO7KN9jZmeQJbctk8Zigb?=
 =?us-ascii?Q?dMZnAM7BOjV=2F4TujBzr6OZLUqLZ7PQGBGOW6AOa?=
 =?us-ascii?Q?h9EU14a5K=2FrXXhmznM5HiQkS06ohe9BHJzVnC3W?=
 =?us-ascii?Q?QyYlwxIzWUNHkTiYzMUXI+445YZPEwmpKP7kQn0?=
 =?us-ascii?Q?U26suYfKmJKG7PXz8mncmDFxEHSt0xgeuYLt2Et?= =?us-ascii?Q?UE3K?=
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, Jens Axboe
	<axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin
	<roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Xin Yin
	<yinxin.x@bytedance.com>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, ian@honeycomb.io
X-Entity-ID: u001.GRlkmHQ+Ka/CKxmoC/CxTw==
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi Andrew,

On Mon, 28 Sep 2026 16:56:12 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> IMO the above two paragraphs are the most important part of the patch
> description yet they're in the throw-away section.  They should be right at
> the start of everything.  Thanks for at least including them - many do not.

Thank you, I'm honoured you took a look. You're right, and that's my
mistake: I was used to commit messages leading with what the patch does,
to help maintainers judge the risk, rather than why, to show the
benefit. v3 moves the problem and its trigger to the start of the
changelog:
https://lore.kernel.org/all/20260928-wb-dying-cgwb-flush-v3-0-e35374884667@honeycomb.io/

It might also help to say this in Documentation/process/coding-assistants.rst.
Its step 6 asks for "a detailed message describing the problem, the
solution and a Fixes tag". If it pointed to "Describe your problem" and
"Describe user-visible impact" in submitting-patches.rst, assistants
like the one I used would likely lead with the benefit on their own.

Thanks,
Liz
