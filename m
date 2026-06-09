Received: from mail-qv1-f67.google.com (mail-qv1-f67.google.com [209.85.219.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2385C400E15
	for <cgroups@vger.kernel.org>; Tue,  9 Jun 2026 11:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781005342; cv=pass; b=QIpYQTGtq0kTpfAd0lM82b5jQ/U+pLsuqedvsKiplC+tNzilDD3gQLr7aYgv6vL61slCqDjWgvicUb6YNCiur5EMOgv3CtXj2rh5M91zr0RurLjUZTON2OPCI38umd/QW2o45GCMc7vMrKK/uKQWN6iv8EgCji6Mtv9arVqvH0M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781005342; c=relaxed/simple;
	bh=lZahKJJVe/nElVoJF5mGEgxxp4lOFM/xPbEibG6nZto=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=WuzXtlGW8wDU555cfy7q1vGYCKkEv58UPFVxMyTjbYadrA6r6e+dkbicXtFYe+dJA3pqJlcLwqnFHyhHpFBbZp24uQJ81NSm1y0OUYBf8m/xPq9tauAT6/FYbtdebpIfvlSs5zRlG4HiXnMI37qRsAPM0ggzUyBGse+B8nZwVjU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aAbg9JEC; arc=pass smtp.client-ip=209.85.219.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aAbg9JEC"
Received: by mail-qv1-f67.google.com with SMTP id 6a1803df08f44-8ce9df48e1bso53718456d6.1
        for <cgroups@vger.kernel.org>; Tue, 09 Jun 2026 04:42:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781005338; cv=none;
        d=google.com; s=arc-20240605;
        b=L6Vxh6f/KxNYJStL3npbVnL4Yvu5NoqG/HzBT217SytuCSHwrIvolY8/t+TF3/BI6r
         09sUKZmqkRO/kdPjisiqYcKtzoQOsr+cfN2dISLFRSYjOA3E9YnLX4GSh6v1CTVgHrx7
         WfQ9jr8fSURE6WWRBg75deIXppAmNUBfkEM4tzh/kO/8tcYJsJFU6B6xw71Qcb35hd+x
         rhGZOSNHzsbbfCFDG3tkXzdSXsTy1SsWAULvBTvMq40sBxpidORDWH6ATbQhxr87wMr+
         oMRg50MSMHqFXNB85/QNqW4O3OPU6fcFZsuvDAczYk6kKRTcXS7Wn9ol1a7uTGK4gmKZ
         AaXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=zPHGFXUCMBQH6l5HOHJr2FVYQTZtYPpvIAEtCs4Ydmc=;
        fh=cJT0ro3bmtAGByAoWkOZ7y6hUdmRUB0hJhLWOH6t6TE=;
        b=XzGzay6RO9whvsg88fTmtrF6XLAb7dTc5yGylFY7cd0jy7YrPVeQpmLvn9XKCrOWTy
         uv/3JpF8H8KI/SPHgeQhqZkozJF7f9iiFdBOcBJ3GJADvY6DduTbdbcCDn6azWAs3rC3
         HD0e2bTLxMT4TYuPr7UDPbMzPNuuVbx/ETXswJ5moOjzgia3n67DVca/+Bg6tuQLJNk/
         i3RcMmxq+O9KQHIEXamc76MuQCUTN0vFIIL8ajRRkFtEKMZJ5hdz7mq2GlYHvBnimxSz
         FlQkqkFBF3uEXDikirO5odrIl8iBcodon9NEPMTJMrjpj2t2yriA32VQxkkoAbQSVjwH
         dHpw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781005338; x=1781610138; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zPHGFXUCMBQH6l5HOHJr2FVYQTZtYPpvIAEtCs4Ydmc=;
        b=aAbg9JEC6gh2AWA279mppumRMDgxDR7rgmSzODG7ajJ6entqQqfpoZoMMDsfhwv7oV
         ZhT4gXV5x8fSllKjEC6HCHnJrHMwYRyGg06o6IkhNx8Khy+72RJsb3fGlUOqEmRRfFIB
         HUk3kDX92gLTyLmn9CtuYZSjE9FQyuFdGZSAuMpzqHy7WlY5xutFR265gAzTuIYWgPa2
         NrOgS2XziUYKbX5i5KQqS7tD7bzqrS+wcvNr0eAQsv2UDNiT98+bKqKgWMAvD7nDgwcR
         KMBFVmdDTpC6rhJE2a3cAu9lXsmHfFzFboHHIotiTPIdhZS1+tfRxGvZq4XhcyK+Kkez
         l99w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781005338; x=1781610138;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zPHGFXUCMBQH6l5HOHJr2FVYQTZtYPpvIAEtCs4Ydmc=;
        b=Phu6l+fu88yAAl/Hm8Bn833gdNYmwe9MhbjfW3KtkvRKMcxGkDpf7HU4X9hHPyW+xv
         VoVcZbgvBG+YIVZV6sTWfCEycUsobsHhOT5xSpEYGnAVHd/jRFSPiv5VmaWdxAeiSada
         7ummACQxp3JrSPZBLnN9SZc7tYkBWRiiRH3wUKKq/QbNH5D8igSj26/LGeZMiTh0hmsF
         wUNWL7M24bdFwILy7Conyv8F3AoLQ7zB4lrl1WxH+2+fpLP0sHkp5Qf0tBqHtxHSTKQg
         pfpb9w7l+SNQy27DBd5UlDa175Rs7m5rYEOvsi6Ys4qxNGsuwl34EQ63dV0dC+MJSfl3
         jxNg==
X-Forwarded-Encrypted: i=1; AFNElJ/kjI33n+t56uvgpykR4f+/UJil24lJjIzEM++c2Os0fB+5VL4Bgqz9MScuDP+rh1gK8UcckDGj@vger.kernel.org
X-Gm-Message-State: AOJu0Ywm2QCXbzg1vocQBL6ZlbZZSqEMl4TUUPEfGfjTgFutQN3GH0RV
	fvIQHpYSepDVSpgMa3vLNl3aBJQ6Efhh3IuCEkQiczji+WDb4SmPsCBR1dN03Ioo+VvyuP+0P38
	Tie1VcwpuIsTnqWMwEIWhlAjXz37q1dY=
X-Gm-Gg: Acq92OGfLpyJ/BShbsoGTw0LZpRBOFo0lce3b1qshrQQvFjMP3MGfXNXGfLodtQzgbU
	toS9jcB5XiO6l6etnqqlvCeotYqIaVybXrgjSk1dtC00VouCqsvtfRvHWecRtOSjMP6FD37+UQH
	FYxmbRnzd/46z/sL9B5jhCPQJiQ/2kAetU1xD8syDxgCscimh62vBQtlTXz9NjGDA6cfqNTnhTo
	Qn3O9vcVtip66uJkk8ZKjMkctxVi68eiyBauUGfgFFkXksnq7XAVPmIqxZDfmUnlHbLP3pIi2q9
	pvPScV0V4CtTefXRufTD5K4OzhA3
X-Received: by 2002:a0c:f942:0:b0:8cc:ce88:9eda with SMTP id
 6a1803df08f44-8cee5fcb3c1mr241726446d6.15.1781005337834; Tue, 09 Jun 2026
 04:42:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Longxing Li <coregee2000@gmail.com>
Date: Tue, 9 Jun 2026 19:42:06 +0800
X-Gm-Features: AVVi8CedgpnmgjSUFjIf3H3BkNpL6r0L84QPtlnw7Oo1l5fSuebp25U7olz4XVs
Message-ID: <CAHPqNmxGfjsKGEJJaSCrJqoU9WHY3q8CX1oTA7GV5BBHvDzgpg@mail.gmail.com>
Subject: [Kernel Bug] INFO: task hung in cgroup_drain_dying
To: syzkaller@googlegroups.com, tj@kernel.org, hannes@cmpxchg.org, 
	mkoutny@suse.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Dear Linux kernel developers and maintainers,

We would like to report a new kernel bug found by our tool. INFO: task
hung in cgroup_drain_dying. Details are as follows.

Kernel commit: v7.0.6
Kernel config: see attachment
report: see attachment

We are currently analyzing the root cause and  working on a
reproducible PoC. We will provide further updates in this thread as
soon as we have more information.

Best regards,
Longxing Li

==================================================================
https://drive.google.com/file/d/1riFUIPWojkYVZu0B5BW8uVPocUWwibqN/view?usp=drive_link
