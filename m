Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=54.204.34.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794315084;
	b=j/Cb1sJ5uAHhT5OX3vA5sCre3eBXKs6RSu9iiQGUNC6F2vWWw7EQ+UosF0IW9jJx4Pr/
	 A876P1Sh+AYlR3XzDWyJw2sQ03yua3CMcR2X7VqLK/ZlgkSNl4U2MjMiYXPkt0BhKUIYS
	 F/NM2wyVN8ovEik0Sy5i1Lmc9wuWqvLURROuFLWq22OU4466sbDclUAFnrAqz+oF5IUdO
	 t+s8D3v9vGX+joCVhYNZFlz40t7x9CGTavHvz7Kej9buXCxAaQ0E2NVaqZnVao+SLdH/9
	 kayp9XrDQkiHC9WW+XgYGCB1FkZfNOhBRLh+e3F5PpxeAak5rVWwjcdHFBMgJ94Q6CQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794315084;
	h=DMARC-Filter:DKIM-Signature:X-QQ-mid:X-QQ-Originating-IP:Received:
	 X-QQ-SSF:X-QQ-GoodBg:X-BIZMAIL-ID:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-QQ-SENDSIZE:
	 Feedback-ID:X-QQ-XMAILINFO:X-QQ-XMRINFO:X-QQ-RECHKSPAM;
	bh=O/4t0fmDlw3ey9yibz/+cpBbJK+aVAgemr+JbdbCis4=;
	b=vWiEuSXBjHXtMZNTJ0Vf6WVDhdlIJ+b5VzdIaaZDqj/giz7d92SeY5ZHH/5UGJJwj4Mg
	 /n/Iho6F/GldMPKvgD22BIX9cqukaPEPHvj/w2DAV/t2KcE5s7z+joWZzgs+TXbYP+VjW
	 A9EGw35eayJzDPWv3eIhbht7yybIXCNf4otVBkSkkl7d4kjBwKJMIZ01cFqN4OvbzOAkg
	 xRMdtyoPL1/86nMhQPBJ/lf/0X8V5i+vEHRF3+9gSYQQy+98IYdJ4BZa/FRlwIlT821RS
	 n0DrAWvZFLR/V44qaCwGIjNzfrmoIvaSAfd3YkzMkTZDERWsD1776tEMebWlEzsAp3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=smail.nju.edu.cn;
	spf=pass smtp.mailfrom=smail.nju.edu.cn;
	dkim=pass header.d=smail.nju.edu.cn header.i=@smail.nju.edu.cn header.a=rsa-sha256 header.s=iohv2404 header.b="aVvjw/hp";
	arc=none smtp.remote-ip=54.204.34.130
Received: from smtpbguseast2.qq.com (smtpbguseast2.qq.com [54.204.34.130])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ECB760A260D;
	Tue, 10 Nov 2026 12:51:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2ECB760A260D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=smail.nju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=smail.nju.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=smail.nju.edu.cn header.i=@smail.nju.edu.cn header.a=rsa-sha256 header.s=iohv2404 header.b=aVvjw/hp
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=smail.nju.edu.cn;
	s=iohv2404; t=1794315073;
	bh=O/4t0fmDlw3ey9yibz/+cpBbJK+aVAgemr+JbdbCis4=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=aVvjw/hpJcwffUAD3ZJb8WosgfOpDSSEIvdMOHTUqrt6tFElF5BK+LYgmP6d43qmB
	 C9bbNv4He8wF4l+U41F9DlRg9gQFsyOfP5JIXAk0KBl4ariKW9EtR1nE1AZR25ZgjH
	 guK7NB7KsoAqcVzzAdOwGhzTJCQQbs679chUlYRo=
X-QQ-mid: zesmtpip2t1794315072td94b9037
X-QQ-Originating-IP: kUPMYRU8RXedmnEzvofaVAd6aIx214/gp9wE5oQPGe8=
Received: from workstation-Precision-7920-Towe ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 10 Nov 2026 20:51:10 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 14794258371886372565
From: Kang Chen <k.chen@smail.nju.edu.cn>
To: Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	cgroups@vger.kernel.org
Subject: [PATCH] bpf: make css iterator stay drained after NULL
Date: Tue, 10 Nov 2026 20:51:10 +0800
Message-Id: <20261110125110.2935707-1-k.chen@smail.nju.edu.cn>
X-Mailer: git-send-email 2.34.1
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
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:smail.nju.edu.cn:qybglogicsvrgz:qybglogicsvrgz5b-1
X-QQ-XMAILINFO: MACXe2l6e7j9/++3jLIITc06cpcQ64cTdZReiCI/CQ+524grdLXPi7lK
	TCyPU4QSTQOlGUkAhQF2QeH+WHJz8lV9A2Mp0gD8gPyJdwYzeHboC2EXF+sVPsC3qINbLe0
	MajzBnrvoDd3nHYHiC4yp0XGITso+Az9j81XZNOq5BS7js+4I402cyx8oM4PGUCj8iDeD7V
	HAanYcgQs2H02vHViUn93Sg4ToqQiRHTLsXkOZLIMXCa7FgBzxMrcmmBmNrVsWD92z8BTQH
	FiNGI9j5ENyxZeJ7iec3ksb8aD45a7VTJMBHQRf6PLQC6ifVEI7F7Ani3ws+bHMCqO/hOQ9
	ERLC+9xyAwbjdh81qbetDE8TOvZt/BJWxDWj5xq/ttyK5eg8yXFsWS5C3NH6cW8rF+A+TZL
	ESeVHwMWOj18Kh0H6vj3HyUSH1m7YCj8GnZztuGpb5Wks19upe6M81DKUO5ifEnAbs50LRU
	c+drtj7n7G/pN3duM7oBCdbRJF1H7pH2Zl9ztKFTiY7MRwXXrcX/ZephfpvL2lv88Fornth
	gE9gKbQsTyFdsYK/HJZYsK0U5/+Gcpxl37iDC8uXVygeNLOn6EQmiw71MfSWqmcTup3oUPF
	47Os4wDhmHNebd99ce1R7MSOJbdWIODXzoXhwA+bau1/Hh+F8GnNfyFF00dpWYejifjgiLc
	z/QMboZ4aHSKIjtz4s/QE6yMWu45YTcbLxceQK1FkXJRRLotQBcxzxQdKA8f9pMboSVebq0
	7HHdl3+mjzw5vEY8+g72uuNCb24GI2jXvdrJNehIq/i8/nWEj8XKhxy6CkOxsEQhAfXX/H7
	a9g6Qg2vZBdWzIskylsbmxNO9htWzHv6lF6ttoRUfcMGyUspXwxQZz0LGoDSMts07gXtOzQ
	9PMNlumkRGmTMNUxO+aVFnb9nQkxRwPkFFKQsIMjO2dDtF3VfFnsLbMVtLlkzeDzB+wBzg4
	2gX/Y8C5XVT6u7ntPXknGEgS93wMbHTpi2jToM6yHqPfDS25lgrghTAfJhlmNBZmehfJcfX
	uY53mWsDqNlbVjlsh7
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
X-QQ-RECHKSPAM: 0

The css_next_*() helpers start from @start when given a NULL position.
bpf_iter_css_next() leaves kit->pos == NULL after the last element, but
keeps kit->start set, so a next() call after exhaustion starts the
iteration over from @start again.

The verifier relies on the iterator contract that once next() returns
NULL it keeps returning NULL: process_iter_next_call() marks the
iterator DRAINED and treats the result of later next() calls as the
constant zero.  A restarted css iteration therefore hands the BPF
program a kernel pointer while the verifier believes R0 == 0.

Clear kit->start when the position becomes NULL.  bpf_iter_css_destroy()
is a no-op, so no cleanup depends on @start after exhaustion.

Fixes: 7251d0905e75 ("bpf: Introduce css open-coded iterator kfuncs")
Signed-off-by: Kang Chen <k.chen@smail.nju.edu.cn>
---
 kernel/bpf/cgroup_iter.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/kernel/bpf/cgroup_iter.c b/kernel/bpf/cgroup_iter.c
index fd51fe3d92cc..fb7ba1e45590 100644
--- a/kernel/bpf/cgroup_iter.c
+++ b/kernel/bpf/cgroup_iter.c
@@ -365,6 +365,16 @@ __bpf_kfunc struct cgroup_subsys_state *bpf_iter_css_next(struct bpf_iter_css *i
 		kit->pos = kit->pos ? kit->pos->parent : kit->start;
 	}
 
+	/*
+	 * A NULL position means either "not started yet" or "drained" for
+	 * css_next_*(), and all of them restart from @start when passed a
+	 * NULL position.  The verifier relies on an iterator which returned
+	 * NULL to keep returning NULL (see process_iter_next_call()), so
+	 * clear @start on exhaustion to make the next call return NULL.
+	 */
+	if (!kit->pos)
+		kit->start = NULL;
+
 	return kit->pos;
 }
 
-- 
2.34.1

