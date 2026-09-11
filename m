Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F0736A033
	for <cgroups@vger.kernel.org>; Fri, 11 Sep 2026 14:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789138033; cv=none; b=g+t9DN/h6TvbNuZOWbNotaiYgZK6SSlqlbGTA6Fjhz/k2l8TKRMFyWjLnXz96VzqWIl56ihwVkxRM2y4wFldYNsoOBbfNvbu4Bc5XtHDSaF7nOY95qm5RaRzs+pRc3TfUMSRrJUOp/8RLxec/dJW6cPDTizSJ0iINLOs9XR5fgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789138033; c=relaxed/simple;
	bh=6qK7Y4OCyC5WsOE2SJMQ4fti6jzNs1Pji9/QbACrVAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DouGD3Sslvwuv0ZSTdss04hgufAu41FpGAkpnwPA9LpwKXgWs18m52DicVPn1RhXwrWQ6riAVqQBgTETtOW8mOGvGWniCiZ6L01H3BnhgpIsMa0TuCivlk+MRFHO0TIXsZ6AXy2GjPgQoO/TW8pZ2JPQxo8mqDM9MRnSubhehL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=A/5m4Fh/; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="A/5m4Fh/"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-482ea739de2so670383f8f.0
        for <cgroups@vger.kernel.org>; Fri, 11 Sep 2026 07:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789138023; x=1789742823; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QuYE5JBWhvW9oHs2kdysh3HB71WxLYQMcei9gKN4bpc=;
        b=A/5m4Fh/sngCKaEoJLtOhd0PEwql+T8zBi0qHa6cFg5H9HZAwcJa6OQkyRfUkv+4l5
         PrwPUM2nfa2NQ5ZfES2qecayX0h9xaZPjNb5dZ+gNkld9Gq+JI7LtsTkqcJdS043KHXL
         AYrw5uKonljqZ69+949bBF4VmJLQCR12wMLd9GTD7yU89XnGbPwo5FMSdRPi3bUSbnco
         ibBekgmGXt2s/P3iIX1rpyu/BfwNKBORTLgqjA1B0N5VgKnIbC7oztcfa1lA32Qmm1Fp
         rZA6+wXmHyJJXapZZo9qqcM+UPHrA+PTNhVhLBZyYMs5jY9zkFEivXrcP5idys2xQ9LL
         Xd5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789138023; x=1789742823;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QuYE5JBWhvW9oHs2kdysh3HB71WxLYQMcei9gKN4bpc=;
        b=LvvtKLSNyuIM2BSeezOwUiGkDu0dwwDRj3ZMZ0RLrhu/f2QwKUewXf2ZLfydZpE/lM
         ZQo6F+1gmQRUl/WVdS5/uHnijqU2iNc+SDM0AMQ5L7n7yCBDyREMWnKcW/FMrj06pYdJ
         1kiwLG8Whm9DiWYOZ5fWlON9vYjrXNbYfoqlz4gjUKfxw4ciK78DYht/Nx1A6zo0f2mr
         U47s/KW/JwsLR2l8Boo/dj57oUE721qQAQP/H0tKqSTjfeTYzV4KOuDML+gvMV5XT5Sp
         3TknSDRrdx6Ecvu68M1ZUwuQoAJnOs5Sc5OXcufVE/HT/pm8Di6c+m0QOCaLobiZEwNd
         v5fw==
X-Forwarded-Encrypted: i=1; AKwUvBy1deWq7rwEnF7gF1dbdgSKlz0fovuR0X5Re7bf2CtTwq9l897TbrbOA9aUSHR0swJNEF0ocxUR@vger.kernel.org
X-Gm-Message-State: AFuF++mv0ozMb2yqomTQLTs2QxeKDLZQVvvENac16V/NtxRVLbkjBrt6
	j46rM8LrEv1DVQQt1ia23/rOAciBFtS+DBnb2nC6sc+Zflc/PbBMgNLiIm/hn8R5fBk=
X-Gm-Gg: AYBFou0OYGItSdfGW8nyOC5em6yaW4sIRKUdkZMhV5LF0v33Oa1zuf8b5u7X67o3QDX
	DgSKsXOA9n7Da5ZTBEXeC6BuiL14LHQaGnC30ooCUtQiDj6Bnq81efWCUsvEwhCamiookjmYKRh
	4SJmjZ1+7cNKVl15hmhPx96GbaSLpEbUGSAFd7AVm4v7dMj3y7ot2TC2wcfJFlwZJo8B0sHg6+e
	wNKiqFrsAXG02eZbP7UIpz3Fh7/zBRndEKPg4iSNRmkIMz9T0MQEJZV3QBMQemwUtNay1N/On1g
	daV6rl0RRyAbGMwt2KRGjxh8LoaJlezRbkDxSwhzU5JDBpxhFjPmVwt2eh5S8Xcc3NWKJd61eFU
	VB7VgzsfUJHhqsn147op4LkEKxm9v+AK8UpVMP/jGbMQYAfzIOnKun6+3ip8EJL0eoFSrN0OByK
	cK3LVbjYl22wUt11A05o4Qbc5bHDkVOjLlTIN17Ipo4/7kjoVRvKCzhKD+SOlQzpbxjuWoFT5H7
	BGQcA==
X-Received: by 2002:a5d:5e08:0:b0:486:e81b:842a with SMTP id ffacd0b85a97d-486eb358ab6mr5259626f8f.48.1789138022582;
        Fri, 11 Sep 2026 07:47:02 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-486eb32e8d1sm6328068f8f.11.2026.09.11.07.47.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 07:47:02 -0700 (PDT)
From: Petr Pavlu <petr.pavlu@suse.com>
To: Tony Luck <tony.luck@intel.com>,
	Borislav Petkov <bp@alien8.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	=?UTF-8?q?Christoph=20B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
	Jens Axboe <axboe@kernel.dk>,
	Johan Hovold <johan@kernel.org>,
	Alex Elder <elder@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Michal Januszewski <spock@gentoo.org>,
	Helge Deller <deller@gmx.de>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>,
	Tom Talpey <tom@talpey.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Pavel Machek <pavel@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Kentaro Takeda <takedakn@nttdata.co.jp>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-edac@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	drbd-dev@lists.linux.dev,
	linux-block@vger.kernel.org,
	greybus-dev@lists.linaro.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-acpi@vger.kernel.org,
	linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-fsdevel@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	cgroups@vger.kernel.org,
	linux-modules@vger.kernel.org,
	linux-pm@vger.kernel.org,
	driver-core@lists.linux.dev,
	bridge@lists.linux.dev,
	netdev@vger.kernel.org,
	keyrings@vger.kernel.org,
	linux-security-module@vger.kernel.org
Subject: [PATCH v3 2/3] time/jiffies: Include linux/sysctl.h for proc_int_u2k_conv_uop(), ...
Date: Fri, 11 Sep 2026 14:46:15 +0000
Message-ID: <20260911-module-include-kmod-v3-2-6ebccc3e0731@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260911-module-include-kmod-v3-0-6ebccc3e0731@suse.com>
References: <20260911-module-include-kmod-v3-0-6ebccc3e0731@suse.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

jiffies.c uses proc_int_u2k_conv_uop(), proc_int_k2u_conv_kop(),
proc_int_conv(), proc_dointvec_conv() and proc_doulongvec_minmax_conv(),
which are declared in linux/sysctl.h. It currently gets that header
indirectly through linux/module.h -> linux/kmod.h, but the latter no longer
needs to include linux/sysctl.h.

Include linux/sysctl.h directly in jiffies.c ahead of removing the
unnecessary include from linux/kmod.h.

Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
Acked-by: Thomas Gleixner <tglx@kernel.org>
---
 kernel/time/jiffies.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/time/jiffies.c b/kernel/time/jiffies.c
index 213ae1d6a014..9231fea557ce 100644
--- a/kernel/time/jiffies.c
+++ b/kernel/time/jiffies.c
@@ -8,6 +8,7 @@
 #include <linux/jiffies.h>
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/sysctl.h>
 
 #include "timekeeping.h"
 #include "tick-internal.h"

-- 
2.55.0
