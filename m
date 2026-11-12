Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.161.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794480348;
	b=0MAY3BPbNy34tJV5RgTKWVkV+UsctkKwaszG3b3NKfIBVkV5+O9wzF6LPFw3ueWnRa7n
	 EVWw75yCC9SLsZG93kvxmWPrR93ErpZ+LX5jrN63LDx5ZnBl1GAug0UxDSM7qRioyrJDz
	 lsr7DC/ZitBZhqVLEaarHT8RIDMlRDoNfV6lOj5cjhc4gKzftJ7BrbZ5OOOCjiqhT2+jW
	 EZqlG6xHAWJqQ235pfQ+ZbEPQnbRDWHqevv/rICJNOrcMJgOtZEymma9TNZysRYCIo8/E
	 L8bc1+M2oU4FPXshjocsG0AoVeE3V4nygbs/2eBB4yar0MwWQXGSeq5aigjUkMJVvlg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794480348;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=ddYVXCpBhwQ+2ajmiZG9m0k4vsq/lXRN7BsHqaZoQkw=;
	b=g9RNFJuEE+twlp+IhDWEnVA5W9/urNombAxrwJcLiSerumhd/A9fb9bv+7X/Hgt+MBRs
	 ag9uymV7WyQCQoND3zmJ9gygBEj7Qb3r8D2WRsrEPqCXE8UzY7UXKfjsPWPiaRcnvDdTU
	 9o3t5h/AxVuj6hYJPNrAjv+hsTx5zU0S1X3XsjOcvGXI3YeY8v8BfVW4DM5nN/eSDc5Ap
	 7X7eD1OUSSqjZaUjmYPY0m7lvr5eTm7qdfBirs+ganmqGtqRDQ9jZXty/hetzxqKrpF8E
	 eups/akT87ohZUmKfz94jNLXTJUvSblOVOB7WfdEyji9Se9oLEISqXB7VIrkjp6rCJA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xcPiMBtA;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.161.44
Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F100A606A8A9
	for <cgroups@vger.kernel.org>; Thu, 12 Nov 2026 10:45:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F100A606A8A9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xcPiMBtA
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-6fe4372c5f3so2393247eaf.3
        for <cgroups@vger.kernel.org>; Thu, 12 Nov 2026 02:45:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794480347; cv=none;
        d=google.com; s=arc-20260327;
        b=F0KQn/hY3Jbfe2CZ2XdGEzhyHQTboYNSxW4XqBYKBvL0b3wHJTigtYgmfEQZBtvkpx
         vfJpcMIwbqUFD2R9HsDioaGGhKmi6IKlFM5Vxd3p+BcFCjaWB5hZ+HdKeXxR+YOMP868
         aDWfZow9pCCd6kETB63Uj9s65RfXdRr2cYzkoGqMrCWGsEKM9RZjZrKtg+C4YvOyrflp
         x7MMcIe8T0hLlIhhxYuqfaTtSnN8q8f7sF+dMs2vQabqAqwGayDd1T50PmtUze/qv+M1
         Cqzugj1X/W0CyGkr7a7qwiEVlWRQdqpL3XIfeA0dmPtj7TKueH+471vdDtzNYmg1bGSP
         Desw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ddYVXCpBhwQ+2ajmiZG9m0k4vsq/lXRN7BsHqaZoQkw=;
        fh=KngaClA8n+nKRIk4gtwFksIJDpddif5HXg6uJrJ040c=;
        b=O10k0/bYUOO9pPwfTT5ZMYIE4+fhVVjRWBJXMdmXYBl5GAGvTPz+C6SqFP2PyGBNYK
         XdaxxGEZ313twGMKm4KRQWIN4FSGKnxSsJzKAJiXRWQBfz+rMBWKO9hqG9ag5IUjY9oX
         DhkEZooiEEREXvwVxFSsI8qByj0AREEFalRcaEM2EPMPdMV4ZznAYlo7f69dSHfAMmji
         cbY0UaAfSfYZCoJmrP8KL6zins8HMQypdG7xQVoisxfVPIidLu5nfOF6eF+svYe1G4U/
         2VThD5e0Nrcbp0bFZt5V3ERUzjQnd0f+xVUWFpndqGrVBPJcDnj+ri4PF9ppJq8aAE0f
         EAJg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794480347; x=1795085147; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ddYVXCpBhwQ+2ajmiZG9m0k4vsq/lXRN7BsHqaZoQkw=;
        b=xcPiMBtAELHn3sgyKErFDHKe52oZIdZV/+UcUTJI51MVq34g1dR2eDj2nxtlt6O8gN
         ujxl9Kp9NnxitTdfcTiU7WqI0qa/lANz4ihDJAVj0BDAMGEHP7tr+TCelsKdxbzp18G3
         76DyE+oRDfmbDAilSh4EmN3LaR10QHrrnzWL9YKFcGqWSCIHGZYuP1NjuC1z+BZN3dFM
         8snWKAclZQnbkdGtLr68y3k5r2aQuv9o4eFn/9v/7VnPHBWCpEpPHp7/LGS5cDcJrUgg
         2dKjCloKWuJEZjPp+YRKZgkOxYf+LYmZJAACS2/6j4uCcShl9ONNzfmKBhuj3OeIQYKM
         8Chw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794480347; x=1795085147;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ddYVXCpBhwQ+2ajmiZG9m0k4vsq/lXRN7BsHqaZoQkw=;
        b=mfuJXpGFg2t3IOGzti7XNDioB4rWq67uRgGuJ9sy9Of6hCm0ESwNJbzk+47wB/0fLC
         KvTucf6Bu7zlwgPqpX/5i09LTQYhIcl+b3272plGdIoQHosC3e+XtXney2rCrYCeXOhn
         dz685CEJIjZjQtvCcg213ZS0StEtvv4DkV9i43qFO/tbYfBBz+wCqICuoOTl8IcTJmvv
         eg2DbNQ7VqaWj3zPBvxvnuT0bvaNcXYKgZByIEQRHPJYJhigdR9g3lnU+eP62B0GNxTd
         twC8ol47KJClg4U83eQzOW3Q4/l07dkP0CAB7GWk40l7js6t99O831GPLBpjimci94uk
         QBvg==
X-Forwarded-Encrypted: i=1; AL+hErHiypwZBc9rVi/JE3+499gkOVYrlAfnrRHefdwcwzqn1M81oh4ZHJtUi7i5Jr4Co2EYxEl0zytU@vger.kernel.org
X-Gm-Message-State: APuU4Z+JXRyvp5tJuw0e8A/obLlabXZBF0zSOa9vsepb5EM2ONfvT4ZE
	hW6DyBIioMIkBMY6tB9csE4/hxwF58ePpTCTxlsGrw+q6xPw7MlaGynMQdocpOfusZKOApgqP8O
	+kCWoHk2JuWFwKNAh4sMz2N/56D2Pckw=
X-Gm-Gg: AYBFou06YHitTdPpq4UW0ImA2423dhB/QnT47PkU3AZwhT9QFwvYzpvqe+sRUA2x5Fe
	y7rrnzXHyj2TxeZ/LMH66ywvFiYBnpbdf5TCxArzTchd2fiuPTrSfenjIFkcbAXw7lzhST9ug3b
	vkrVpyXADHDQk+uxHLfZX6jdF8AedmEjEkpARRKQmmiG4LSyf/YvQzf5y9qRsXsQGjUlk3BIpbB
	2GLtppRPLnnVOolXv4Xo4bbHU0v/BpVsttRpwsiDuIa/TGB6GZ6Y44ND9TFL6v6CeKUm0JACByK
	X9k3wG5+J2o/GQxfHxmu28pGRovEwAqcsOWxo4mA7Ncy1ScQ2nXqN2FjjFKiYbXJ1rKBC1LxQR8
	CI/m1Uk+3tQcDrwf0WiH7tXUAKDWdOLmvTs53c4o=
X-Received: by 2002:a05:6820:1621:b0:70d:77b7:6879 with SMTP id
 006d021491bc7-7191788d816mr3318135eaf.36.1794480346869; Thu, 12 Nov 2026
 02:45:46 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <avA1wXhTMs9eY2NF@chrisdown.name> <6B8E9261-3FF8-441B-8F47-7D35834A8D35@gmail.com>
In-Reply-To: <6B8E9261-3FF8-441B-8F47-7D35834A8D35@gmail.com>
From: elenchist <elenchist.dev@gmail.com>
Date: Thu, 12 Nov 2026 19:45:34 +0900
X-Gm-Features: AclHuK8UhlNcIj8rZxl-jPAQ-TNb4Ro929pQ1QbaMvl25O9AF4j0sdfra1fF6R8
Message-ID: <CANYAW49zq97w7ptUO6xkXZ3e+CNMzWH7qxQ1bQu4an1L6_kXuw@mail.gmail.com>
Subject: Re: [PATCH v2] mm: memcontrol: Don't lose track of exiting OOM victims
To: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Tejun Heo <tj@kernel.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Zhan Xusheng <zhanxusheng1024@gmail.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	regressions@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

My mail client turned the backslashes in the reproducer into yen
signs, sorry.  Every yen sign there should be a backslash: the printf
format in overkill.c ends in backslash-n, and in run.sh each of the
two "$" right after "echo" has a backslash in front of it.
