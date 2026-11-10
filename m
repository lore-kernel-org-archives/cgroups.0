Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794271849;
	b=zyV4jRoiEssboJzkQDhnOsvqYmC9/TdkM9TFwCzYNCvcXKFEJMA8Mw7q37P547wc7+1c
	 /dXRCVip/5OZHL/H9R9IGt/mL/F1S+SKApVD6zme68KDw2ScoH3WwwqILZzGe1FZcn6zp
	 8vrYyCgLq2xVYwRaxmEq+Hxh1WYAPO9atRrv2lHg2KgRXiukH7pyXQlDr6ajdUm5ThbG+
	 2Sn5iEUayq87temwqbzYvpEL3xC8zKYEim6Iyz7hEG6AOeEEtxzxYwVp4/k/1LCUZxRP/
	 IcJRBJ4XZu9Coscnkf9tPY1cpzmZp3oECmcLcUsDD3ooqKzA11F/9hpJxHD7VD887mA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794271849;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=9aUmjjXy2UpFvwIaZx+Kc6emVkBoaRCWFUjyBYUuXe4=;
	b=ZMxqHZG6tp4NCyVBpwQam8D2sue4JxlO+JMhPj/HabL4jzw8DAvdI7dRLwI6BTMVF2n6
	 mXo63rvggUaGlwIrcy/6mWz2dAVtF3MbLsEK8TgOjOnjCYuHY+yTyoOEaDUqwFvXHSdWw
	 18zf7hXb9Q5Gf9n9yN42qz612pGxPeXLlPK5SBtNHm/So+9eshqpsLJ1tFwXLC0Eigd3h
	 nPr/75Jm5+I2qnr2iJwg3M/qV+V8ANGoOlLrUqsZnGyXGpA8WlmuuC5zJrTRg0HnvRgOf
	 d/9vig7O35gMvnfOSAQA2eIZhxu7xjmwyC4QAYEqUID/2g00E0TepnFYWjbbnyAEX6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Rxqy6ixe;
	arc=none smtp.remote-ip=209.85.215.200
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C58606A32A
	for <cgroups@vger.kernel.org>; Tue, 10 Nov 2026 00:50:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 01C58606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Rxqy6ixe
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cd5fd34fee0so863352a12.3
        for <cgroups@vger.kernel.org>; Mon, 09 Nov 2026 16:50:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794271848; x=1794876648; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9aUmjjXy2UpFvwIaZx+Kc6emVkBoaRCWFUjyBYUuXe4=;
        b=Rxqy6ixetikDYH4GXTU6DVlNgIzULph56hr/ylPgKBEq0LAlCxBeqtn3zqJLm8xcn9
         /8L8gEpu0FFua1AhJKLHLRbGekFetzUJMpAhLvBkyd6Io4I8yVRJ1QPbOdpOumJxKtNh
         oMHHHRmbLW+xy9nfrbL3O/Y/GIENxUCBo+qprlcK5nHvk8Mf74MAkBQAagwOLqXMK0gK
         01XQLwADmqO9ZRtOrPv4jag12vYH76y4TtBVV6TFN0ri4rMmBiFegEp+AZT1vNUQOljj
         UCk05FbvXMpWSKjhnKf5Yt/0k1VwOGa3C7NyCBNMU6nsHzQkxBdxpMV8/sXi1UpwGU7s
         PIyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794271848; x=1794876648;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9aUmjjXy2UpFvwIaZx+Kc6emVkBoaRCWFUjyBYUuXe4=;
        b=RpcD0F48MEsj8TCGz+w6Vs/lDrWeIE2LKs3lk1xPCn509mvbwfZWAPSvYIUS8LVytW
         EhC0nbz4IGMh9IFTT5U3SJw0110cvE98a5Xk49E8LamKbzt6EH6q4ugJNRUsvN9ssVfn
         9u2AWjsC9623u5Ur8z0mhJ3RkDLLY0TUooTeDzsnxYdHwGxvNoB/DFeRFN0VNFCcAKNQ
         jQ8esbq33KOQ3Vjc3UxF+Y8XVETjft5mPxQKwFI0DV19IlEo1oaV208uIUbxYxDekxQg
         BjzHIy0ILPugymHgOpL0H1eorcFvDsyVFiXDocHdUZ9v1KmNzDtKTkI1nMoTIb+sFKkZ
         3IMw==
X-Forwarded-Encrypted: i=1; AL+hErGTCUoDI/DzdsFt2NMCHjqFALP7cK+qmkgWoAelJzXwJCzBF/IrK/sCB+m68fo/LEIc9dySGFLY@vger.kernel.org
X-Gm-Message-State: APuU4Z/pqNgqcoR22xE3Qaqea6+n31cMNoP8DI/tZ/+Z2a/Z2aSejWF7
	4C5CJDLBIWK+ne9dOw06VsZXCWk6twGB9mK8NRHZb6BT6StQpuhvS2mbmxwSh7sKudMJXqIbCrs
	7nSqpKw==
X-Received: from pjdq9.prod.google.com ([2002:a17:90a:2e09:b0:3ad:32d0:ca0a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a48:b0:3ae:898e:a123
 with SMTP id 98e67ed59e1d1-3b166cd70c0mr1265220a91.14.1794271848067; Mon, 09
 Nov 2026 16:50:48 -0800 (PST)
Date: Mon, 9 Nov 2026 16:50:47 -0800
In-Reply-To: <CA+EHjTzaJx2nV_9YEExgYn7STSP1Kvhsqan8va8M7ba4WtCiqQ@mail.gmail.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20260922071945.693714-1-fuad.tabba@linux.dev> <20261007074037.316564-1-fuad.tabba@linux.dev>
 <CA+EHjTzaJx2nV_9YEExgYn7STSP1Kvhsqan8va8M7ba4WtCiqQ@mail.gmail.com>
Message-ID: <avJqZzKX1ZVAMGr-@seanjc-mac.roam.internal>
Subject: Re: [PATCH v2 0/2] KVM: selftests: Fix incremental build dependencies
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	"Michal =?utf-8?Q?Koutn=C3=BD?=" <mkoutny@suse.com>, James Houghton <jthoughton@google.com>, Will Deacon <will@kernel.org>, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Nov 09, 2026, Fuad Tabba wrote:
> Hi Sean, Paolo,
> 
> Another gentle ping on this series. Is there anything else you'd like
> to see before it goes in?

I'll grab the KVM change, but I would prefer the cgroup change go through the
cgroup tree, even though Michal already acked it. AFAICT there are no dependencies,
and it really has nothing to do with KVM.
