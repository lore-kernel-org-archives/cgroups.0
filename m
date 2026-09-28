Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4F94F6483;
	Mon, 28 Sep 2026 20:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790625658; cv=none; b=LYAWvWajJgtLkZJFJZvSngvGwfcp+2OGppG4k8/HymwnhFc0cyExbTWfrh2UT6I8cLelCu3TYLdx/UY7zKy8fvQurr+XiXTQlLmRTCS3aY9v3n6drEpeVOBhdqrq4gX0IAWZjxMbuEv6pTDzcwyGm1RKBhIitBObk2h2UTUBgQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790625658; c=relaxed/simple;
	bh=SopRBs7O5o3d69lmp3KkpKZDCg/7ZdSGHUvWPTXc8V4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=KZQmxKmV3oopLobCEtdeczcobR6Fs+nhOGFk7FuiIpNNxDLaXD8iv5d5SUthcoBSYKfOGpIiY5Z9EksklqI2vmTiajJ1BQVVGPQtBqNtc17RBzEmtspai7NZpqQta8fibYIY3zFHEwbt+uSO+1K1rChB9XEu/7JYHm1NfRxwmjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=FZqS3nbi; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="FZqS3nbi"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68SI5acM1642773;
	Mon, 28 Sep 2026 20:00:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=3CgW6u3tR/aoyojWa2wdAq6Bg/Va
	QhuO287Rhf/vJxI=; b=FZqS3nbiepFwVSvOD0uBgomdI1FrUbkvBiRx9plU8itb
	XW/m+QHwYPkMXCYDrIQFgou0rX2iJrgP/FdFeIt3/kf+5Q+KzQjuApuWxsRgtfGA
	/w8Dlco1yr/9qiMtSLHUOPVsEvfyA2F4uv5vEJQKUxlDwkaC7BHl6yc0noN1Q5e2
	mQ84tyw5T0WgZHOLhs5oascLc009UTI0YRCviOeBbLr3tGkrOZAno1unsO3TqdiM
	ObHjAAgKHsLbnrbLSWIsvHSUCtry6edsrq0SYlyf6NJfRrx+lLdrIZYRy1RoPNxV
	le2wSScIiBWLSwlqzN8/f4G5Ui4QU65CsEa40mmrIQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gx3fk3c5t-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 20:00:51 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68SI2TeI525891;
	Mon, 28 Sep 2026 20:00:51 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gxrcppxwh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 20:00:50 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68SK0nHI40305014
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Sep 2026 20:00:49 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 33BCD2004B;
	Mon, 28 Sep 2026 20:00:49 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 40F3C20040;
	Mon, 28 Sep 2026 20:00:45 +0000 (GMT)
Received: from vishalc-ibm.ibmuc.com (unknown [9.43.92.38])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 28 Sep 2026 20:00:44 +0000 (GMT)
From: Vishal Chourasia <vishalc@linux.ibm.com>
To: tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com
Cc: cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vishal Chourasia <vishalc@linux.ibm.com>
Subject: [PATCH] selftests/cgroup: add settings file with a longer timeout
Date: Tue, 29 Sep 2026 01:30:34 +0530
Message-ID: <20260928200034.1769120-1-vishalc@linux.ibm.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: BiKW2WjqvottcmDwzMeCUQHaJjHnyqLP
X-Proofpoint-GUID: BiKW2WjqvottcmDwzMeCUQHaJjHnyqLP
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI4MDA3OCBTYWx0ZWRfX9Q6kE/NWxJFJ
 w0YWoQ7bXnvj43N3XioDWQC8g8JDBnKiOFZgzYtzZGueBE41YPdzka2YMwJlPu/6hJ+YXHuVQAb
 T1md2GpYL6FyJUrnZc0082X0+Z5KHss=
X-Authority-Analysis: v=2.4 cv=Vv62kO2n c=1 sm=1 tr=0 ts=6abac773 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8
 a=cM6yLABnzD-VEF3jybsA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI4MDA3OCBTYWx0ZWRfXyB+55uvEkbAi
 4qrqEwQrPqtd7hKBrCVTgfElR5kIHRTwSPSNRZ/j4jwbfMB81RHRQeHNGJdELiumb//V8DQ2BWw
 vXY2wI+h0tL8weAbgUOupNMSuoAmaUTz9aHFKOr/5DL9ugVYLjKoyqAO/vOEK9ACFDNeb5Jf0qo
 Ghs2h9Aho5U55sHf+uKrsizFOm1mrnOm/EmyFwzXgy1Oi7mhWS8PIMgG8ycgF1OohmwMC8Jyuiv
 sVpYAr274vgoc0ALsG1KrzzlGfkOad41ZkIg2uO43Ikmcy5049rsxeHuKN/RvROLJC3PcMR+IX/
 nfERjpbWMZuVa/0xgxJwtR395f4TbZT3pfeoBDgKDLw0RQEn04xxNNwrYQFVOVsogUiK4nl8jyy
 COdx3jYbdnLjdM9ZdmOfA/ugkMoAKFSKpGfTygSm6IzIMUSZQpDI48nLWAtLi2rIhFRgs5Ml96a
 Kv3S1BR0BuKue4tNtgw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-28_05,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 malwarescore=0 clxscore=1011 lowpriorityscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609280078

The cgroup selftests lack a settings file, causing the kselftest runner
to apply its default 45s timeout. The test_cpu binary now exceeds this
limit, resulting in timeout failures that prevent the final test cases
from reporting results:

  not ok 2 selftests: cgroup: test_cpu # TIMEOUT 45 seconds

Test execution times:
|Test                  | Duration             |
|----------------------|--------------------  |
|cpu.weight (×4)       | ~10s each            |
|test_cpucg_stats      |  2s CPU time         |
|test_cpucg_nice       |  2s CPU time         |
|test_cpucg_max        |  1000/HZ seconds     |
|test_cpucg_max_nested |  1000/HZ seconds     |

Total runtime: ~46s at HZ=1000, ~64s at HZ=100

When executed independently, all nine test cases complete
successfully (46.2s on a ppc64le HZ=1000 guest).

Introduce a settings file that increases the timeout to 120 seconds,
providing sufficient margin above the HZ=100 worst-case scenario.

Signed-off-by: Vishal Chourasia <vishalc@linux.ibm.com>
---
 tools/testing/selftests/cgroup/settings | 1 +
 1 file changed, 1 insertion(+)
 create mode 100644 tools/testing/selftests/cgroup/settings

diff --git a/tools/testing/selftests/cgroup/settings b/tools/testing/selftests/cgroup/settings
new file mode 100644
index 000000000000..6091b45d226b
--- /dev/null
+++ b/tools/testing/selftests/cgroup/settings
@@ -0,0 +1 @@
+timeout=120
-- 
2.54.0

