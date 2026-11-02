Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.126.103.232
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793622352;
	b=pW7vajxNcxVFlMrv+7s/qI09SmMd3vH2JuDW1nxgUDNPVFXIX8588R8GJy5K2KEWpPzi
	 KvGqBDuWP7I+UV8PZ/r5rbrGGx07kJvcd74FLdcJCVAGzPO+mbMynQTtIozQlmLe+OKCL
	 /Nrn7RM/O3q3EmRIvULxAvcfvwHFgDSuhCzDSv9/VYZoRFCtGN3wVl7AIeviKF2AXz9hf
	 gsksmm06BbTyCysNJ+I51lygpz+lJIXt8e77jSOeZpsKYtyX0E3DUEZrIhD9jSIR5sAG/
	 zh7L09Y6DZnLzDH5wOi8NIzemdNO2qW+z9SOQAsKuACkP4Cs4atr5IcsnM3dNUkjYLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793622352;
	h=DMARC-Filter:X-UUID:X-CTIC-Tags:X-CID-P-RULE:X-CID-O-INFO:X-CID-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:X-User:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=QWxekjA+fe1OvVXW0+7PF8qydE4AHzzyYdNfB4ajrnE=;
	b=iBDuO7wBOOcFlwoJNbRcACIpqXEiGWeZ0rquiah56Le5HcyXiyBtuFG9dVAhwIjM2v+U
	 9XfIY5uqT5DchG59UI1BL7skwVXl4L4pcWarhauGuDT2ID5HpEh4UR+dkuS6bcTfAHauF
	 ZyGMOwfxglSnb85vQlmV1hUXM+ULZ5thPhFTFywCv1RTC+xdsxXKe4imdELYeVpSw/haP
	 nB8MZfDqvOq4itTJ2ScHviJa8aFUo7/XntOzJ9wBrrBUm92Z223n4yQLVc+OtazEpnVuX
	 KvvKpE9k31xIDQkFPa2BBINwxaoXEBRVO7SjfqWGaB8gSJKtP0R04QkrcxJpAW1hDFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=kylinos.cn;
	arc=none smtp.remote-ip=124.126.103.232
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F7F606A78A;
	Mon,  2 Nov 2026 12:25:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 10F7F606A78A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 84ea5216d6b811f19a56ed5b684f684d-20261102
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, SA_TRUSTED, SA_EXISTED, SN_TRUSTED, SN_EXISTED
	SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD
	CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD
	ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:f7350ef6-cc28-49c7-ad94-79cc583fd268,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:f7350ef6-cc28-49c7-ad94-79cc583fd268,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:3a80eb27c71bdbd8150ef340657003e0,BulkI
	D:261102202544AR6ZPRG3,BulkQuantity:0,SF:17|19|38|66|78|81|82|102|127|153|
	865|898,TC:nil,Content:0|15|50|99,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:
	nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,B
	RE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 84ea5216d6b811f19a56ed5b684f684d-20261102
X-User: husong@kylinos.cn
Received: from ctao-book [(114.244.3.119)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 155186156; Mon, 02 Nov 2026 20:25:41 +0800
From: Song Hu <husong@kylinos.cn>
To: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeelb@google.com,
	muchun.song@linux.dev,
	akpm@linux-foundation.org
Cc: tj@kernel.org,
	tjmercier@google.com,
	ddrokosov@salutedevices.com,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Song Hu <husong@kylinos.cn>
Subject: [PATCH 2/4] samples/cgroup: exit cleanly when the monitored memcg is removed
Date: Mon,  2 Nov 2026 20:25:26 +0800
Message-ID: <20261102122528.1498193-3-husong@kylinos.cn>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261102122528.1498193-1-husong@kylinos.cn>
References: <20261102122528.1498193-1-husong@kylinos.cn>
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

The handler processes IN_MODIFY only.  Since commit eea5d2bb34ba
("kernfs: Send IN_DELETE_SELF and IN_IGNORED") kernfs delivers both
events when the cgroup is removed, but the sample warns "No IN_MODIFY
event, skip it" and returns to poll() forever: after an rmdir the
listener never notices and keeps polling, while a supervisor still
counts it as alive, and the cleanup_memcg_events() call in main() is
unreachable.  The
accompanying selftest, commit 2de27980e1d4 ("selftests: memcg: Add
tests for IN_DELETE_SELF and IN_IGNORED"), exercises exactly this
two-event sequence.

Handle the removal pair by printing a clear message and exiting, and
subscribe IN_DELETE_SELF explicitly.  monitor_events() returns through
the normal path, which also makes the cleanup call reachable again.

Signed-off-by: Song Hu <husong@kylinos.cn>
---
 samples/cgroup/memcg_event_listener.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/samples/cgroup/memcg_event_listener.c b/samples/cgroup/memcg_event_listener.c
index ec7c03fa7887..996bf6fb117c 100644
--- a/samples/cgroup/memcg_event_listener.c
+++ b/samples/cgroup/memcg_event_listener.c
@@ -199,7 +199,7 @@ static int read_memcg_events(struct memcg_events *events, bool show_diff)
 	return ret;
 }
 
-static void process_memcg_events(struct memcg_events *events,
+static bool process_memcg_events(struct memcg_events *events,
 				 struct inotify_event *event)
 {
 	int ret;
@@ -207,19 +207,27 @@ static void process_memcg_events(struct memcg_events *events,
 	if (events->inotify_wd != event->wd) {
 		warnx("Unknown inotify event %d, should be %d", event->wd,
 		      events->inotify_wd);
-		return;
+		return true;
+	}
+
+	if (event->mask & (IN_DELETE_SELF | IN_IGNORED)) {
+		printf("The monitored file %s was removed, exiting\n",
+		       events->path);
+		return false;
 	}
 
 	printf("Received event in %s:\n", events->path);
 
 	if (!(event->mask & IN_MODIFY)) {
 		warnx("No IN_MODIFY event, skip it");
-		return;
+		return true;
 	}
 
 	ret = read_memcg_events(events, /* show_diff = */true);
 	if (ret)
 		warnx("Can't read memcg events");
+
+	return true;
 }
 
 static void monitor_events(struct memcg_events *events)
@@ -247,6 +255,7 @@ static void monitor_events(struct memcg_events *events)
 			struct inotify_event *event;
 			char buffer[INOTIFY_BUFFER_SIZE];
 			ssize_t length;
+			bool keep_going = true;
 
 			length = read(fds[0].fd, buffer, INOTIFY_BUFFER_SIZE);
 			if (length <= 0)
@@ -254,9 +263,15 @@ static void monitor_events(struct memcg_events *events)
 
 			event = (struct inotify_event *)buffer;
 			while (INOTIFY_EVENT_OK(event, length)) {
-				process_memcg_events(events, event);
+				keep_going = process_memcg_events(events,
+								  event);
+				if (!keep_going)
+					break;
 				event = INOTIFY_EVENT_NEXT(event, length);
 			}
+
+			if (!keep_going)
+				return;
 		}
 	}
 }
@@ -291,7 +306,8 @@ static int initialize_memcg_events(struct memcg_events *events,
 	}
 
 	events->inotify_wd = inotify_add_watch(events->inotify_fd,
-					       events->path, IN_MODIFY);
+					       events->path,
+					       IN_MODIFY | IN_DELETE_SELF);
 	if (events->inotify_wd < 0) {
 		warn("Couldn't add monitor in dir %s", events->path);
 		return -EIO;
-- 
2.53.0

