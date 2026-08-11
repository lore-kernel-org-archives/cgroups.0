Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1BB63E16A0
	for <cgroups@vger.kernel.org>; Tue, 11 Aug 2026 19:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786476024; cv=pass; b=JZSMA2mEPHbXLLsLp+mjlIw0iIHOq/pLkFRi/jwbXMlRjSwniKRxXqjhKfEesfWRAXVArLk1KULZz4RgJQazDdToenkoYRLVLV5Q6EfOhV3hh9PuTZT/WK4NU8VPcPjay3hBuPtnRIwrqyEbW1dtxE0eYgImfnh2p65u5Qjk8cg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786476024; c=relaxed/simple;
	bh=C0tI9qUXL0/pdjc8WBu7cnqr0pTI/K9DzaSGDO9Uh+8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oxFnd4z20wsbdolfU3hnU7lOKOKMJtuQzZD03kSaydguZ/HhzMjrvJbSJEVFz051+iiODmq8VYWSn9Ob9x6eD0d7IzXCC7yCsNhkr7rqSo+V0FygP5WiDZ3OL7keoWliHWT2TXJQbU1kvqZWVyZjyHHeV22u0VbET6dJzxz5g2g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KCU4SOrz; arc=pass smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KCU4SOrz"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-47f6609c657so57619f8f.2
        for <cgroups@vger.kernel.org>; Tue, 11 Aug 2026 12:20:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786476021; cv=none;
        d=google.com; s=arc-20260327;
        b=pIFKNiqWysVYTZhI9H2hAphMPgcJJxLewW8i7A+bXooT3rgPh/juZFXMO/bUDkELGa
         PpmuYEiN9y4p1dSybSyGiahtcd+O4Nmy5ALaBEE2xqfu6HUzb64jWiIZhbrp5cDJMafD
         cf+RWITh1Z7nf5B5NfOgEFJqwAIOXvGBjPF+KpVGteI7CC7xaHCGFTikBiGM9sMGkI4A
         MRx9W80bY/roa8NpCoJdPF5Mq0Zy0zQ/XNsK9rGea6vnOcruBqANxkkY/y32Gv9axF/2
         +uduHbuhdHF9JiPSRAgjGY3VvNHpsKmuxg/I1qLxb/IeNXu7YWd4D634NGm+jROICypG
         jKKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=C0tI9qUXL0/pdjc8WBu7cnqr0pTI/K9DzaSGDO9Uh+8=;
        fh=LszG14FfcUS+X0M7D0uaLrnwsTV+6lACx3lk+gO884s=;
        b=QfREPG0MlWXjnsiynFVaARMvj3JrKUqhxcXbYQNDQx7Bdk7gR44jI2DM5lyeQUDzl1
         mBrPhgvU9saGYtT/ETHj2CIqpgKVkbjOzS7Rv2wyt1g6NfEHmyVJ6tpFrSgpTIy3788e
         i5zz7+8a6LimxgdJNRQckIuUvoZai7IZJvPGhYc+5ZnA129bsZDE0AYNUChQYTJMakWV
         uOA0KPsjRUv+1/FwGQM+iANNHRDprCPfjoWs2Rz3eJ71uKF+GuVmYbR29H8TfRf0vMI0
         ClYxgpInTM61JI5h1x1cEJmgGWGC/YmsvPe39c+MZF0K6HoNgIi/PHMezQjbc1TUjDaC
         rP3g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786476021; x=1787080821; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=C0tI9qUXL0/pdjc8WBu7cnqr0pTI/K9DzaSGDO9Uh+8=;
        b=KCU4SOrzWqy2IGPAUvIoWgHGsdDmjZ0xtWdy+5OE8QtINqkuG6paayEDj8fYQvSmXN
         YkkVQtJ1jFHmAacvjitdXL+xZKfHTEoTrmAkxF1Td3cYwMlCoFNrs/g5SjpuAKE44x1k
         tH61+/ZoFzsOPDph9OIZVftPAtYTcyyZc1EED1WTDTC0DSBj4X3I8mYtl3tX6zxvPu6u
         oa3DG34cEkOTn3Q6gT/pXl5j8FHnku5qqMhYlJp9t3eZdnqO3JylhnGWy1wy5Iy9ZagL
         J1WyueYEoVJzO9ob54fIZBR6LOe/reYlkMriCXjWywLxwNi27ykGILPw05o62TG8+50H
         C/kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786476021; x=1787080821;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=C0tI9qUXL0/pdjc8WBu7cnqr0pTI/K9DzaSGDO9Uh+8=;
        b=CAO3XK5jxjB4ijXDRhG6hEmc/v7QTHFgK6PTDdT3LfIdS8Bv+KFjmNSnM2vlXzvBdj
         UhwS2dpN6KRhx88f928r/bFRopSL6FCYD8lgieLV44Vb24vQr8QMMo+O7OJ3vq4B/zgx
         N/etzpfjRkrhmUuKSw/IAZBhZD9AZgysmkdkP/c/arVBj8s3P9SfjbIve0Qc6sItHD3B
         LsFFNZfWdPP8xkxOR+SCEQvno9YzU98aHDhUMAc0gI5JOCEsOkKtA1fw+6d5vMyz8glj
         D3fVvL7sczH2WqokbvDmIEWaWquZIZfK5ZmcT6OREcsk8r1m2+Hli7jhOoYX/DDQlTA0
         0WpQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq/1CziGOWQtjhpivM7sSU+IfkrZTYTQbdX6d8FAus8qxuEy9HAHH0H+VQ1XWNJn/ivv4vgxuft@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5yB2QRwIh+rQKPKS0JZ7Qdb6xTOXFXSWh4o5LlW/C7ue/G8yM
	dTZV8QA9TbiB/v8W/IlgZeiTtC1ZNQ+LkeL+o+evMDuRELD3PMNagg19vueLcepLIQzqdFemP0q
	F5DaFgjdr5JkseROO1UzuQO3L/yWD+JE=
X-Gm-Gg: AR+sD11ZnG83pBKrVYWwmjQ5q3litVj/UhWG4OKqJrnRykr55eULE5hBp6QQdn2cLyq
	4ER4UNWf/3cB82vYIqZR0zrsF06LMPcCUyV1dvIQcqs/CJrO5pcz/SqOWi9Oss+H7eVAZK5JmFN
	/ZOJcZiRvjnZE+fZONIRV1RlY5ry2J4N+ksaEAZztxU1Htsr3zE1svilifF5C4rcF1vXJYiDV0i
	6/wS8yRcVcSQq5kERZ5AsBpfoNfs+r9hOys6wT9OvxjwpKLMOEq7OBjhf2HJhLghYTLypk6fs91
	w4jazueeURZsGvF72lIv4vSEeXE/RhYRAQTXjyu4aPl8ub07Udnvauy4+nb0IIBSCsJ+OLZdFf7
	B
X-Received: by 2002:a05:6000:2687:b0:47f:d072:87d7 with SMTP id
 ffacd0b85a97d-4814ad8531cmr9844062f8f.9.1786476020845; Tue, 11 Aug 2026
 12:20:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260811051434.3805648-1-wfelipe@google.com>
In-Reply-To: <20260811051434.3805648-1-wfelipe@google.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 11 Aug 2026 12:20:09 -0700
X-Gm-Features: AUfX_mxREYM0a5ro6axfuWwtuNUtoNVGyXynzVlYalBNbqZUMOkUoPV4WEi7gaY
Message-ID: <CAKEwX=PW8D6z3Oq7o9OYGXV1YF3g8mxq8rGDU-Tjn2FQQZ-XZg@mail.gmail.com>
Subject: Re: [PATCH v2] selftests/cgroup: test_zswap: skip test_no_kmem_bypass
 if debugfs is unavailable
To: Wilson Felipe Pereira <wfelipe@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 10, 2026 at 10:14=E2=80=AFPM Wilson Felipe Pereira
<wfelipe@google.com> wrote:
>
> test_no_kmem_bypass() needs to read
> /sys/kernel/debug/zswap/stored_pages via get_zswap_stored_pages() to
> verify that compressed pages are charged to the memcg.
>
> When running in an environment where debugfs is not mounted or
> CONFIG_DEBUG_FS is disabled, get_zswap_stored_pages() fails, causing the
> loop to terminate early and report a false negative (KSFT_FAIL).
>
> Selftests should not fail if debugfs is unavailable, and it should print
> a message when it is skipped.
>
> While I'm here, also add a warning message if the test is being skipped
> due to totalram size and make the check for totalram more readable.
>
> Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>

Acked-by: Nhat Pham <nphamcs@gmail.com>
