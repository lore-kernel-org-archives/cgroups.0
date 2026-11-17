Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794931794;
	b=aB6aZFOPuETUna8mZtAbTVIMKUo6CYNs2+OaSJLeGZ4ogXMTMT8SVQ+QmqwxknrxsHE0
	 Y7LUYqQkZfoFyvE/wnoCgPEO+ZwfI7aU+hCDSewdgVmYBd+KC5WRV0OPDEJDReYEaefEn
	 PJy1UPkv2srNa4MzMpT6OfrFbgQbSnbeufvvzuJhoLylDchRr5GBBijWUxjcFj+VZ8DMF
	 NzbeIOr1EhIMFBe7qydCBqL+NN8FAYSCvywT4TQcar35sm5f0NGID9G9qVZYwRXz88SF8
	 toFWEaFqaBnKpTFajZHJI6F65Lsw2Y/KISNC+JZA5/8RbGA3cW0w7zBo69CABgM1i8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794931794;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JB2dNhYg4YXLTwJaNiAZq3d5g36BXulx7lVZDawKnfo=;
	b=HgVIASFxxvQ7ghznZQeI/uUbF4iaY7cNSByrnW8i6fVCloHCEG0qAQyo6bMtoS8lqwwb
	 9/qOOXZ1q6ag9vgLd8lqeQ+Cct4Aad5/epKj73rPspXDtHyfqHHjvisZzMb6UfPuH1qYa
	 upXmch162UmJCJ0AVWgfhN4Wjl2b89JV6XkL2HWapb54OjaY+JsLwnP1CJxFESkBpVTxz
	 M+GTrMAG4RnO6UprLFjuCsqrlyP62o6I//Vyi52JATilj76nB/VpYeNpeycaNjyQLfzOc
	 xFQmUmrQjfrGdlfEuwHMzoqFhLcLoXyFRxgFLnlguxWixhepnvmW+1ZwAoWNmHlZURA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0T3bCjjH;
	arc=none smtp.remote-ip=209.85.214.180
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C19A606A32A
	for <cgroups@vger.kernel.org>; Tue, 17 Nov 2026 16:09:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7C19A606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0T3bCjjH
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2efde3200c7so4296075ad.2
        for <cgroups@vger.kernel.org>; Tue, 17 Nov 2026 08:09:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794931794; x=1795536594; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JB2dNhYg4YXLTwJaNiAZq3d5g36BXulx7lVZDawKnfo=;
        b=0T3bCjjHf/iTE8Gsh4RoOPBCtelkusLC77/NkhqnT3RkHCR9S75Il7inLONgYMJXVV
         5OSZIiNj7tyc8AgxDqRtgJEHylLEt4HlhXJAWNzGaVlWknDeyAlu0VZ8XwRTIP/UKu7g
         3yPFDt6fHDmc+M/5w32K8NqJiTy9l0WFHpjnWC4UKkIPSlgAhRw8Shy9TAiENZQIGXut
         EI4nFeBWPnbTYEz0oSeSITKGGPx5iQaGjH1abBRD43rhqKYekoURhUOT1CPyX2BlaUqP
         HKB2q8832zPzBffiz19k0eJFjlPLACtOsgGBApNr+ZjRHMOBqUWcUBu5iUyMlQdIXyM/
         YjrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794931794; x=1795536594;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JB2dNhYg4YXLTwJaNiAZq3d5g36BXulx7lVZDawKnfo=;
        b=jd8Tts5v6l45oA+kVOufL/4XOwJqXZiFu/bYqAUzX1ZlmVotxvyQeOtaOuQJ83JBCT
         0N2NTBa4pAYpY/Va/eHGKf6hArLFEsU4gZhqMqDTtwCTwm6S9LwVeKvjaF9Di5RZrlsg
         XqdJQaAB0XbnF/DOztoPwENzW7ef6Xg/1zwC+IohEO4RqDpRdtnmAaoCTqP/s2tcQxmm
         85Reb0aNkzy2uQ4DXNIe/3jT/3CKGGxr6GFkUq01NP1saSOioQASHK6s5ZXnOuCS6XSf
         rc74FSglU3ph/mthb2x5pLjy2z0d4bBrU1PcCP84cimb2Gt8EfsnkY5BKtaGHtvFJuWr
         vX+A==
X-Forwarded-Encrypted: i=1; AL+hErGmzmKR/tvAh2wfPHtI8F3QXEBsnWN1Xs95BEOQM2I1nrPjeIahReJQ6bZohHyKurThH9BjVmXO@vger.kernel.org
X-Gm-Message-State: APuU4Z+HhGmJXxbopGAWJC7eSKnVjbmRlUP21W3UyoBop/57yWK7wNVI
	8TzfClfEpYVTP0dLa0xCJM4q7MbXa59vyCBrhHtT1ltUoIMxEruAbHtm
X-Gm-Gg: AZFdTZccSkcA8Ko45M8XsdN6W5uweyEbIgJydUkn8YGT9pwfBKNsfNPa8VqLSzusNaH
	0CQpbZxMkvOc5fae81UPc+AWzo5AGdiQYFg9GYhgWVgYSWz14MNnRjp1LQwx7fMHj+1V+F5slf9
	32t/qgPKA/PP5OAjlh1uaea12eKJM57X0nZ6h1+EN1o94EE/wrgngumkhu4uSsCsqRwkGOdDkR/
	XOZW6DUE8jZImje3JmhAN9jEZibRafe46x/QyZQM3V7IsGzBVgAtwh5t3lZA45RGgBtH2xCPnlR
	Qs6TChcKFMRIrJY8/oFPTCjc7d9kX7/gxUYA1XCWB+qfK3w7L86vIqIVPVt4r8qI51azh01uh3A
	AU0nV2GADy8Gx8g6wxmZBZXh1fmPj+aKqqMCLXb/0XYRcQtBnqUQfqxxGA18ayaTyAXrk23iS7F
	KH26p+vl9nK8VrcIfWLeFFcGWkdEL4wcw3TlCPf9BAuZNxldKvkg25+CSlW6HUWYcNxulJ11Hg9
	03xBRp9iRLgcbs5AHqiGp/G8ZDDyYY+YVubf47SPEQDCqj3C0NXZaGU+qbanxWzYzmccCjviz+j
	PEG1sqx188XzhIjojA==
X-Received: by 2002:a17:903:32c7:b0:2ef:dc42:10b1 with SMTP id d9443c01a7336-2efdc421364mr28930395ad.49.1794931793688;
        Tue, 17 Nov 2026 08:09:53 -0800 (PST)
Received: from naki-PC.localdomain ([2001:df0:a640:2::19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eff61162c2sm127965ad.12.2026.11.17.08.09.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 08:09:52 -0800 (PST)
From: nakixii <nakixii@gmail.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Barry Song <baohua@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Peter Xu <peterx@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>
Subject: Re: [RFC PATCH 00/16] mm: add in-memory compression of reclaimed pages
Date: Wed, 18 Nov 2026 00:07:39 +0800
Message-ID: <20261117160739.475062-1-nakixii@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <avrliOfBi326au6B@kernel.org>
References: <avrliOfBi326au6B@kernel.org>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, Nov 16, 2026 at 01:14:16PM +0200, Mike Rapoport wrote:
> This seems to big of a change and the wall of text in your "results"
> section does not explain clearly why would we want to bother reading this.

Fair enough. Looking at it again, most of what the series does is
already covered, or about to be, by zswap and Nhat's virtual swap
work, so it doesn't justify a new subsystem of this size.

What still looks interesting to me is a couple of backend mechanisms,
e.g. packing several compressed objects into one swap slot on
writeback. I'll evaluate those on top of zswap/virtual swap and come
back with something much smaller.

Thanks,
nakixii
