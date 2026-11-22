Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795364941;
	b=lOS4g7eYsmM+UiKh1Ks2BHziFDKtWTqFqxH2qbrG4iHTubeJQ86kNAjpjGawbItOmGqm
	 hTv/pSevrq8CUod2VIFpiPXKCofyOoM6U8uqNl4WxM7WeO1bm71DR46k7Q8b/l7ld01he
	 /Ktm7xJJ3HZU+q+2Di+DVWSim71EMrK/bdCr2honJhxmV4TVO5/09tjGRxLex5Q4Xfr+C
	 TWWRsAj+CbQ/QxeKmwHp2bEgtyLHad6mo3VYsdjLrwlQvjjpva/9aJYbQeguu/dvzhQQC
	 nd4RLaoPvVDeeIRMYpZniyAx9COiPpiltVKU19LLf7mjAnMSJEQSGvlfkEfb054kdKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795364941;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u54RhPh31KUc6Mfc10ElYw3foIWIoI4CAHG9i2sGAtg=;
	b=Ya+PiDNKZQ81/IW1FIXJJRa/W/lQ96R4U+U6pm8zwsBwwjvUr/cZ7qZ5rKDEZtSNZY0V
	 S5+9NzDBTAa79Qy9yD5DsQ+VVwRYvpwkcG4VEsUTB7ShaaZIhF6+DMz6hYaTaLVu0mcrl
	 YUnniHdKw2ThP5xi4INC55JlsFDT7rAOHOS/3n2YJqM5/jKeqrJLKl0wcbdCd884+EptX
	 wHpMcQcJruh/qCigkT1ShllYjPflD+ejtMij1hMqUYUrwEfnCKmcOqVKR6rskLJkJoa2Z
	 7RVvfWPurT4amGnD1//gN94UXaBwBX0qlSFsHvBjmA+Mu0K7u2WwliqBkVgAL7+2Ncg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=quD4BYCc;
	arc=none smtp.remote-ip=209.85.210.174
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D72A4606A331
	for <cgroups@vger.kernel.org>; Sun, 22 Nov 2026 16:29:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D72A4606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=quD4BYCc
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8a070781f63so1107614b3a.1
        for <cgroups@vger.kernel.org>; Sun, 22 Nov 2026 08:29:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795364940; x=1795969740; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=u54RhPh31KUc6Mfc10ElYw3foIWIoI4CAHG9i2sGAtg=;
        b=quD4BYCczIn20H71M1ek8V1tvx7D334/7+k7AnuKagUB4BMWfGzVI4e9xcWDx/egRk
         z5YyaiFK86ipmH7iK6YAxXA7D98G6nPJtabW3lSn1n29sMuc6fqvs/4VOWLICVYP+mmm
         F3QJz3JltyXBiH6CYg9YDbZtwt1v4sLkiAGg+XQkxFGXAKLrgifNDarBAgnUaNXxwqKY
         Y8BqBRsa9bhaJazr/2vaRBPJTNKK7Bz6lkWatYnFyGJ0TiJlGs+I38/bDBLlBFjxO426
         QUQ71JkEHoRj9N7DQWhzji45B9ZS4br/cjc/GkyaEA7Cb8TTKJERhK3agK/lTbZt7kLQ
         wqOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795364940; x=1795969740;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=u54RhPh31KUc6Mfc10ElYw3foIWIoI4CAHG9i2sGAtg=;
        b=quuOJC4KrhzeXHGYOEUzta6lZZeHOmfdUFk5vsUBBYBrHk7rdEGn0P8sGgnXR6wz3K
         8E14BjdnlNsRFWKNKHb3CFYqkYtLwVylZN5pmHPPGUUfEP9kX6WkG0xfE/MVhueZgIWx
         iOWgkst3oC/U24kDpc3byYjPzmSSfdZJVMZr182p/c7JH2gf/jQxV8vmt4YYVo10q/bR
         riaBR1hZQOUNnz2PqwRurZ/vum3DyuclSkoT9J/+WVuvKffPBG8IiLKsjIIdy879lVLk
         7IvIZPqlLBkgO7C2V0Mxss+byDz1iPteeqOmiVEVCqMt/JUzng6njzHpv81NMDsr4pTt
         Rk8Q==
X-Forwarded-Encrypted: i=1; AL+hErHbUYKElOiRfFlQm5LGZci8Cc2/3E9E66mdfY35k/071hmnuLcK73SlLkKzhBgeK3MzoknjqLWD@vger.kernel.org
X-Gm-Message-State: APuU4Z/VJmAFDz1FfEWHCxTsKatJg0fiyNeaIxsXi8cp3FcTn6H/iKfa
	s9PNrTP/VjE+zladSYWrub20sgmygR0eZ2q48ufQL8eL8bNaneo7If9A
X-Gm-Gg: AZFdTZdZVHI1+7u7w8plEkXxWqmBkTF+svOZD+SuoXXVeja3dbR4xjpEE0HIR+7PohD
	HuycEvxsx/bjRofdCFgOXTB53zMzytMwhvceaEg8cQe9bldQIOWxpE/CF0nA3unpTNm/OOABwGG
	gQaDT/2kIxjcYcq9Zlr5PmM4Um/env926zymB5Yj7eyw1HNf7UJ5XjxPY5n2Whyq6uhlNE3IPJ6
	VXA0o2ETmVYc1CzRQDRw92uen4DVtYqFq8q4LBzaIki2+qVKWFFw+keky3W1xUKoZCrhLMwUvkW
	yd+2Lhqh+ieAQICl0EQ8k3dXrdzBLWoz9iYWHdMPnbP7nC5Wo+Sv0RggH+aLqvHW/dZjl1GfnMI
	oHrynN+ZJRVWMKnE/hsf4w4/xutQjwiP+ehkxJWIhXvL3Xe+MGY4P4RCuhurHf+xr07rmaQlwCQ
	rKq7E5Knguk63eiUqncZ+fmujdEapdeYSqh+hV8Q3SfjpwO0vG5WSRbRL7qMv+QVZ0yAQNVWr1Z
	JVm/vBDzJiPa/AsWqHQNF0QcZVTbZkYdxougdKfDTWtV63/sh7XpAbtaBQBZDnAIx7bFLGwVqYg
	7G6niXAjxuHYOEFMU7VlD+v9gAl+m03N7WuSLLJJKjU2rB3uuNKcgCfp255DvJ9TC61VUGc=
X-Received: by 2002:a05:6a00:3ccf:b0:89f:feb6:5d5d with SMTP id d2e1a72fcca58-8c87c95b6b8mr8202972b3a.33.1795364940056;
        Sun, 22 Nov 2026 08:29:00 -0800 (PST)
Received: from localhost (218-35-178-218.cm.dynamic.apol.com.tw. [218.35.178.218])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c8706844a0sm4219437b3a.1.2026.11.22.08.28.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 08:28:59 -0800 (PST)
From: Kurt Lin <lylin1023@gmail.com>
To: Sasha Levin <sashal@kernel.org>,
	Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests: cgroup: fall back to an unlinked file without O_TMPFILE
Date: Mon, 23 Nov 2026 00:28:17 +0800
Message-ID: <20261122162817.2012387-1-lylin1023@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261105011824.1143947-1-sashal@kernel.org>
References: <20261105011824.1143947-1-sashal@kernel.org>
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

On Wed, Nov 04, 2026 at 08:18:24PM -0500, Sasha Levin wrote:
> get_temp_fd() creates its page cache file with O_TMPFILE in the current
> directory. On filesystems without O_TMPFILE support, such as NFS, the
> open fails with EOPNOTSUPP, and with it every test that needs page cache:
> test_memcg_current_peak, test_memcg_min, test_memcg_low, test_memcg_high,
> test_memcg_max and test_memcg_reclaim.

virtiofs is another one: run from the kernel tree shared into a
virtme-ng guest, the O_TMPFILE open fails with EOPNOTSUPP and the same
six tests fail.

With this patch on cgroup/for-7.5, test_memcontrol passes from virtiofs
(15 pass, swap_max_peak skipped as the guest has no swap), and from an
ext4 directory it still passes as before. No cgroup_test_* file is left
behind in either directory.

I found and tested this with the help of an AI coding assistant.

Tested-by: Kurt Lin <lylin1023@gmail.com>
