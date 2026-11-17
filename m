Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794931961;
	b=Z5u1Ztql1VsGN7DjKMn9MP5NrTEdwAPzLAGkcvVc6QtUtJSkkagQTd5fb4HgcQqFctiF
	 olLOOfuICVx30EWphAC7Zr1PqOkp0aixJlGy0oXmu4kul8hZSWRq/pnlkkLrVPFLEbrpt
	 4uyFTua1aqRc5v2+xmJVG3I66D3Ori4I4XA5pSbfdJrMSb+tuhT/r7Ltm5B/PvyApwav9
	 fxSRC5EchB0fOET3R4OGnoy7L1Q4YJO6vN76tj6hhUotHxlVXhnG3sZtFyTrKmfFwfzFI
	 M4IKZzZNBpkzhiPg1tfQO5D0sI/3mtM+iOvQscTwgapMMzTR9fzvZiBAALZUvjS/Tyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794931961;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uUg9oijFJngLvXeo3djJLK5OYdiXHydsItyj0Mca3qM=;
	b=ZTEFB4geqZNlmiU0yzNpn6ALFzkeSI45BwGxb8uk9/A0T0jBV9LWXfZ/5NnDfCyEpOu9
	 GfyKz4obbX2vAgrelj9w1dUIQpHbXgA1SYafGhmvodcdClYMg+TPde+KxYIc7gfRbcsMX
	 MtTVuCHGUfAdssIVNuUzkhUyxa1dzawFclVieCLnk238JRpdv3SJcs1hwwxMwheLrlZmu
	 oW+vq2jyaoLbIu1uoZJdr0X7PvFxLA85ZzWvsMtnOijkl1hasFq9J1CK23v0xg6Ux6CLA
	 ayQ5Fj872vWdqDAAJ6nEHYW3pT4ANotU2X72k8jZAaQurpzdfdLhZzq1sQ3a/D+65Sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Bw9sZlGi;
	arc=none smtp.remote-ip=209.85.215.169
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D630606A32A
	for <cgroups@vger.kernel.org>; Tue, 17 Nov 2026 16:12:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7D630606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Bw9sZlGi
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-cd60c5da24cso44535a12.0
        for <cgroups@vger.kernel.org>; Tue, 17 Nov 2026 08:12:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794931961; x=1795536761; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uUg9oijFJngLvXeo3djJLK5OYdiXHydsItyj0Mca3qM=;
        b=Bw9sZlGiKCoZfi2kf04ctZl/R0ogQmKE1NkNS3ELjWQqjNupEpoc1lQhuVKs8pfbTO
         73Lzj7k58DrseGbgFUa4w+D+xR/LHw/YgOodndT3JoamWJELz+Ft9UNPVxYrtUnJSE3y
         ZW2dnh/FWtvbyf43PEMHNoWTH4DXscz2C5Xf2AVv4ch44ZdPGnVxGucIUWk0oUj6YH7F
         /OUiVp7r+XI02cLN8ssiqOfkny1vmymMirRz+oG/SKwHoJikLC/1E2cXBUebvQoR5V6q
         Iw9fxEhGgls9BYpceht5gadxMbjHmMnvzJKX4VZcuVqG5OOP1GPBxf8AQ2FpQzSNRhYd
         o/zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794931961; x=1795536761;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uUg9oijFJngLvXeo3djJLK5OYdiXHydsItyj0Mca3qM=;
        b=oCqbErafyWTWg342608uhB48W5vDXPSXADtY20xmFVPmsUZkgc8Z6TNscd/uABPQuv
         lvYU7syW6Er8gOYtrtinl+CwHD9XrXvx4kuf1qML5sqPzP/uAshqS/vPnd/0xkQsvmst
         0la0VefSJ3JLDGJeCa0zBELbvsrAPjEM1Ap2TOaF44a3jJOK5hlfNJNiIzaR1bWFqwDv
         dfD8Y0Ozv4iC02eNM1Drhm9B+uTtpaUKitJ9ZxYPy8GW/9gdJ4WfKhEFY51zdyFkRafW
         jWXL4X/p1xl5/Q8BJZ6kxWhFnKYd7CUkriATHCtlVhnX29AJb4YNQXEtzcqGfboQPNmT
         VHZg==
X-Forwarded-Encrypted: i=1; AL+hErE0y8W7GDXI971Iz9BZX1EqEIdVqIZRlzYUu6jTSZ3C8lx+puiprdT9gaCy66Wq6IBFyLt8tnRJ@vger.kernel.org
X-Gm-Message-State: APuU4Z/RGTcg911NVSBc1P0E1X9uzLin0vX3gpC8DycWVU5rVrrk845r
	AOUu2kPcKGAEq668AOH6KnQMnKDcvuiuBiyRqXJneItnfTVcD+OIJN2i
X-Gm-Gg: AZFdTZfIihytqRyl+/0qJSs6HqxATkxo5DHpWd7SnI6mGQFo8FAEmWl6t5IC0e6ENAv
	NiQhnmxQLSGfNnq3eGCYSxCHrig9RhdyHuVEh5HS0LhLyB7j4EqEVwD27POmuKjH0dGUIBdLYPY
	2zWnb5F022KF9A99B4OsHIDv68iTTrGUzKV/+W8Oj6uMYJnG9Ygu6JnWRLkUwo8VyXhKBbienhq
	ZGfBkRMz7Zx1p7+v+j469bH5bItCDBEuu2XKF5tPQKJgbzaTkR0MA0lXgJxoNOzC47HAa/hyQBR
	yBOiVBv0E3Np8QAq+cAwQz9Afmy44qbDRHooxf7SJFyGKfEobzkAkL+eaUntCMUxQTUTLhzQGrf
	RaYs8ZXR8EnKhsmozaEuDTXciw3rhQCpNa0WMzd2GN7Fs26/TOLM6aQ2GRqcxUKT1tQZ0eD/Ohg
	kzi968bjRhGFIfsO3bwASqKq3yeaK9/R8vAj+hiJieRYbV+AnDOjBKaafep+5EM2Wx78I58Rmys
	EN+wJ8nddRB/8XtodBPD4qz4s3kd28cKL3LeAhiAVieueBPVgmpZ6MHfWJUFZmuK/LdYqGC527D
	KGHqt3lGgmjtKW9y4A==
X-Received: by 2002:a17:90b:4c44:b0:3ac:7f4c:a68c with SMTP id 98e67ed59e1d1-3b1b0a437b2mr14421846a91.49.1794931960646;
        Tue, 17 Nov 2026 08:12:40 -0800 (PST)
Received: from naki-PC.localdomain ([2001:df0:a640:2::19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1bfb607e7sm8435512a91.3.2026.11.17.08.12.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 08:12:40 -0800 (PST)
From: nakixii <nakixii@gmail.com>
To: Nhat Pham <nphamcs@gmail.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Barry Song <baohua@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>
Subject: Re: [RFC PATCH 00/16] mm: add in-memory compression of reclaimed pages
Date: Wed, 18 Nov 2026 00:10:28 +0800
Message-ID: <20261117161028.475891-1-nakixii@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <CAKEwX=M64ZmMLBRiAQ6FiiP8f=jkA4m=HM8rgQo-cir2SENPnw@mail.gmail.com>
References: <CAKEwX=M64ZmMLBRiAQ6FiiP8f=jkA4m=HM8rgQo-cir2SENPnw@mail.gmail.com>
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

On Mon, Nov 16, 2026 at 06:13:46AM -0800, Nhat Pham wrote:
> What's the motivation of this line of work?

It started as an attempt to get something like the Darwin memory
compressor on Linux: keep reclaimed pages compressed in RAM, fault
them back directly, and push cold data to disk only when needed.

Honestly, your virtual swap series already covers the core of that
(zswap without a backing swapfile, no PTE walks when moving between
backends), so I don't think a separate subsystem is justified.

The parts I still think are worth looking at are restoring directly
from the pool without going through the swap cache, and packing
several compressed objects into one swap slot on writeback. Do you
think the latter would fit as another backend type in vswap, or should
it stay inside zswap writeback?

The numbers in the cover letter are from 6.12 and don't compare
against vswap, so they don't say much about this yet. I'll redo them
on a current tree first.

Thanks,
nakixii
