Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E243B212FAD;
	Mon, 24 Aug 2026 10:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787568906; cv=none; b=k2j6xBaI1gVfvjI/swXQmUqR7WkcrshBr/UZSQNs51hOK5fnhCpZiWbVmIP9WxMj7vrr2/cBarNco3gTTUe4Tp5XTkljVocaWP7tnvFNLA8u1fN5SWFhO/57VO6bb5Lrf7AVQEucq5tINHX1bGvSpHdYqqgeY+VwkbVasHCSDtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787568906; c=relaxed/simple;
	bh=fkpmiuvZvy8KJgwZoYnlsiK5bivcJAsMIxHfupu4BEE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=p3PCUgAck+otbLdB6Nv/FqQuNZxQoF7sA9ntDzzj1shdpChpCYwxoV6ZbvKQbeIDGaSABIwLyTS3+n/dLQLtJS2NZtX5NixWlxYOwhth79elH1CMtR9hrRhRPv7c/PAE1mVXaGKcvOGWil5gSqKiUl0HRXWh3J1PcKFW1onSLV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j47cE2MZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j47cE2MZ"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6E80EC19425;
	Mon, 24 Aug 2026 10:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787568905;
	bh=fkpmiuvZvy8KJgwZoYnlsiK5bivcJAsMIxHfupu4BEE=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=j47cE2MZlpEWiyZC1otWBKfZrT/JCNvDkpA8RZR0wld1n2MjCNxma3+CuvLla3WtM
	 MFfsuA6RiSbsx/F4hFwK5J0/Z0nxgOLkp3XPvYAVfQEhx2+HRFLTbvBO0YKNMbNk8H
	 zCXdcyuUN4x6SjViPJYndIiRCp0ILnR9Y23K3RTGuDvOlE8ux0G1Jhmxt0LY/7r6p7
	 7NZ/avZrYMbAaZcMS9yFV4NdvQFPnh7dwanh/BUQeUWTgnlpiiC9mTEWqZEZ+UDnMh
	 dhNYGgBch1RFfARMowgJOaaifzySnv3vQylIIeQPrYWlCUK9/mXNejR/NNrnolOlIT
	 qOscGL+cf8cnQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47998C5DF81;
	Mon, 24 Aug 2026 10:55:05 +0000 (UTC)
From: Cheng Lingfei via B4 Relay <devnull+chenglingfei.foxmail.com@kernel.org>
Date: Mon, 24 Aug 2026 18:55:04 +0800
Subject: [PATCH] docs: cgroup-v2: fix misc.events key format description
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260824-master-v1-1-6866b77e1f62@foxmail.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDCyMT3dzE4pLUIl2DpNRk0zRzy1SzZAsloOKCotS0zAqwQdGxEH5xaVJ
 WanIJSLdSbS0AaDjCvmoAAAA=
X-Change-ID: 20260824-master-0bec5f79e6c8
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Cheng Lingfei <chenglingfei@foxmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787568904; l=1986;
 i=chenglingfei@foxmail.com; s=20260824; h=from:subject:message-id;
 bh=bJaj3sDirKHBVj+n44LMo9qeP3F5hcHM4o9UGDzSx74=;
 b=spZdIoOvb0lu29m40uvXEaSglJuDFY8+PmPwGpb0SosQ5MGLU8trU4eneQJj+l/IPYu45yxYL
 GfynoEP+vd+ASU/hf6cauZc2kWUriAJnyuEjxHu810DPfCJcTbxm0jI
X-Developer-Key: i=chenglingfei@foxmail.com; a=ed25519;
 pk=jJFtzwUiUOhTRJNlFx9WjsWHIYGk49Br17a7AD8MH2I=
X-Endpoint-Received: by B4 Relay for chenglingfei@foxmail.com/20260824 with
 auth_id=972
X-Original-From: Cheng Lingfei <chenglingfei@foxmail.com>
Reply-To: chenglingfei@foxmail.com

From: Cheng Lingfei <chenglingfei@foxmail.com>

In misc cgroup, misc.events does not output a simple "max" key. Instead,
each registered misc resource outputs a separate key suffixed with ".max"
(e.g., "res_a.max <val>").
Update the documentation to clarify the per-resource nature of the events
file and provide an example matching the rest of the Misc section.

Signed-off-by: Cheng Lingfei <chenglingfei@foxmail.com>
---
 Documentation/admin-guide/cgroup-v2.rst | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 7c2a8ed80..cfd6cdc0e 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -3059,14 +3059,17 @@ resources (res_a and res_b) are registered then:
         file.
 
   misc.events
-	A read-only flat-keyed file which exists on non-root cgroups. The
-	following entries are defined. Unless specified otherwise, a value
-	change in this file generates a file modified event. All fields in
-	this file are hierarchical.
+        A read-only flat-keyed file which exists on non-root cgroups. It
+        shows, per resource, the number of times the resource usage of the
+        cgroup and its children was about to go over the max boundary.
+        Unless specified otherwise, a value change in this file generates a
+        file modified event. All fields in this file are hierarchical::
 
-	  max
-		The number of times the cgroup's resource usage was
-		about to go over the max boundary.
+          $ cat misc.events
+          res_a.max 0
+          res_b.max 0
+
+        Each entry is keyed by the resource name suffixed with ``.max``.
 
   misc.events.local
         Similar to misc.events but the fields in the file are local to the

---
base-commit: 0a0d1d55dad570724bf8c7ea83409639cfb4be9b
change-id: 20260824-master-0bec5f79e6c8

Best regards,
--  
Cheng Lingfei <chenglingfei@foxmail.com>


