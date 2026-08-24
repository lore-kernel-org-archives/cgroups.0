Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE0B416854;
	Mon, 24 Aug 2026 12:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787575550; cv=none; b=WNj9J7a6qR5cEtfRDqsUi31bsrtCrkdT8+HkHpKG+g75nTHQMIBqvS2/RfC3B95+jn/wo9hQt+H17mPwm1STNKfVSV6ENO+wiT7mtM4tNyMIgCEb0NSiiFbXFV2VcioGTSDIXnW/ON159UxG+TgurpsSiIOvG+V7iVMeNzaVYtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787575550; c=relaxed/simple;
	bh=LBo0kWmjSEJdr3w8AkZS50jaJ1zo0MsrBSgNPFGFXV0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=TlSEKovNLhMGdNxY0uk+TyfUBDcLkOKFJqIU7hQEYwt0Ly/jrobGoNPKWyNPZeHniL1u4eReLv5o6zQvfKeX3MHn8Tk4XGJGJPzTjSS/ZOPBq/FA81ZChPebqT5S5Jhf3f48vthrmphqkVSJTsVFp5esXBgR1vUE7C8hY/4Hkng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FITCu/EF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FITCu/EF"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 647ACC19425;
	Mon, 24 Aug 2026 12:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787575550;
	bh=LBo0kWmjSEJdr3w8AkZS50jaJ1zo0MsrBSgNPFGFXV0=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=FITCu/EFTQWX/iAA+dFi65aluwiEweJnRL3swB3zreB19w7GjfRRhJSqKr0pThQPJ
	 whNTv6ZintmZSOlDHpwbIGtNOD09Z7KcXXpQWMfioVqLJFHjXsyW6gcDo4bdAX9OV1
	 CKlP+pg7qcGJTP7FsjTs4hlmWnRvWlByYVOd3XK1+uauwz1skJ8NyTAC4mdDmDIPBX
	 q/wvHhF8/nytFWobsq6SPM8hFl8+PouzjARt07j04XjfJ9wY46v7Fbbd4HQkpUXLYO
	 Bk2UIU1przs0MQx2+USPKMpcDOennrylbOLAAIn07YA78OSu2iEq0T0Lq9XwYkwe92
	 uFVHwd7Qfl0/w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F072C5DF81;
	Mon, 24 Aug 2026 12:45:50 +0000 (UTC)
From: Cheng Lingfei via B4 Relay <devnull+chenglingfei.foxmail.com@kernel.org>
Date: Mon, 24 Aug 2026 20:45:46 +0800
Subject: [PATCH v2] docs: cgroup-v2: fix misc.events key format description
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260824-master-v2-1-00331c3cfb6e@foxmail.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/2WNwQ7CIBAFf6XZs5hCFKon/8P0ALjYNbYYQFLT8
 O/SevQ4ybx5C0QMhBHOzQIBM0XyUwWxa8AOerojo1tlEK2QbScObNQxYWCtQXt06oTSdlDlV0B
 H8xa69j+Ob/NAm9b1agwUkw+f7Snz1fuLZs44k52URinkToqL8/Oo6bm3foS+lPIF725UxLAAA
 AA=
X-Change-ID: 20260824-master-0bec5f79e6c8
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Cheng Lingfei <chenglingfei@foxmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787575549; l=1345;
 i=chenglingfei@foxmail.com; s=20260824; h=from:subject:message-id;
 bh=9EdW2zRd1zyz6uqGRm1e2H1GPoLMd2RzHiRdXSbyxsM=;
 b=pb+yUPVe3/hm6yx1unRjXXbNHgcVIXaQfUPZniMPlcNHkNWRQMhxqeuWl1QqvVNGTQk4FIV1V
 JWPZOwPGd7wB40i1DJDGuRg9zk2jD2MxUmSmE/UGs3bZ/4bYLLSiCCg
X-Developer-Key: i=chenglingfei@foxmail.com; a=ed25519;
 pk=jJFtzwUiUOhTRJNlFx9WjsWHIYGk49Br17a7AD8MH2I=
X-Endpoint-Received: by B4 Relay for chenglingfei@foxmail.com/20260824 with
 auth_id=972
X-Original-From: Cheng Lingfei <chenglingfei@foxmail.com>
Reply-To: chenglingfei@foxmail.com

From: Cheng Lingfei <chenglingfei@foxmail.com>

In misc cgroup, misc.events does not output a simple "max" key. Instead,
each registered misc resource outputs a separate key suffixed with ".max"
(i.e., "<res>.max").
Update the documentation to clarify that the entry key is "<res>.max".

Suggested-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Cheng Lingfei <chenglingfei@foxmail.com>
---
Changes in v2:
- Use "<res>.max" entry name instead of expanding with explicit examples (Michal Koutný).
- Link to v1: https://patch.msgid.link/20260824-master-v1-1-6866b77e1f62@foxmail.com
---
 Documentation/admin-guide/cgroup-v2.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 7c2a8ed80..6a6fd2017 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -3064,7 +3064,7 @@ resources (res_a and res_b) are registered then:
 	change in this file generates a file modified event. All fields in
 	this file are hierarchical.
 
-	  max
+	  <res>.max
 		The number of times the cgroup's resource usage was
 		about to go over the max boundary.
 

---
base-commit: 0a0d1d55dad570724bf8c7ea83409639cfb4be9b
change-id: 20260824-master-0bec5f79e6c8

Best regards,
--  
Cheng Lingfei <chenglingfei@foxmail.com>


