Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=54.206.16.166
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794537904;
	b=VEqvppSA5yq0Ns5oIZDgRpzic5G9ZwpcoaBjeSUZ6mUdvreazrjuljX3mA4BHKRV/XBd
	 XWoavkzyvsHT1mA5dJmPsz/QNTpQ7QflEZM9zYjup96nalGxI9Kugl+XnVxwq3vvAwyf0
	 EkcyUT+7relsA3BbvRWGDT3nz2MAKddZll0CWIL8dl1VxJK4pf86Jal76nuNWrgTtvk2q
	 mOLgr6se0mPIxeiEz5xdltQb+DShaglTa0z+obRJCOMr/LqC5CZvTSJCvsSAO8H9GcbKm
	 C3vD1SS3/CR+bWlrNq5aUPQABcowQ9pLktX3bK07wQ6KkTzrPdsLX6nRonvjtmcY38Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794537904;
	h=DMARC-Filter:DKIM-Signature:X-QQ-mid:X-QQ-Originating-IP:Received:
	 X-QQ-SSF:X-QQ-GoodBg:X-BIZMAIL-ID:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-QQ-SENDSIZE:Feedback-ID:X-QQ-XMAILINFO:
	 X-QQ-XMRINFO:X-QQ-RECHKSPAM;
	bh=BvnjJ+ijwNCz4Oqh6fIRvQJmHHYb6TrYy/+fUMqfBHY=;
	b=F/0IAY65RdXNgJz3PN5qEA9OWQTXE1v7tzbwHc2nq5GTCoIJzgpDP1Vh9UKiTF0X3miE
	 oQam+QcsLBhPjY5uG7rjQ+IT9cG+Ssh549972O2/qwH6CxR/6PZRUd+c5DgC7JxkdtfqN
	 bDdrF6jYMjsNfupP12TgTz14PcoMFIWAXhwWmb24s+DGungmCcz+4Yy7TAp6d3wqjrTGA
	 9N4tuB7qLjVM065qFZPMFRNjWEOk7SQzixVXn5OepAnPqgO8LwrnxdO8zBeqPZ7cKq1cH
	 /+0w1E2ZW+8mxhCMjBUPBuEiEz54o0QS9bQuZwbjwqaZPPqEHvTKjp9vUwAVMlLt+vQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=smail.nju.edu.cn;
	spf=pass smtp.mailfrom=smail.nju.edu.cn;
	dkim=pass header.d=smail.nju.edu.cn header.i=@smail.nju.edu.cn header.a=rsa-sha256 header.s=iohv2404 header.b="Eyo/eOwI";
	arc=none smtp.remote-ip=54.206.16.166
Received: from smtpbgau1.qq.com (smtpbgau1.qq.com [54.206.16.166])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D80606A321;
	Fri, 13 Nov 2026 02:44:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 52D80606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=smail.nju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=smail.nju.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=smail.nju.edu.cn header.i=@smail.nju.edu.cn header.a=rsa-sha256 header.s=iohv2404 header.b=Eyo/eOwI
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=smail.nju.edu.cn;
	s=iohv2404; t=1794537897;
	bh=BvnjJ+ijwNCz4Oqh6fIRvQJmHHYb6TrYy/+fUMqfBHY=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=Eyo/eOwIwO5xf0JJeC8k8dv0M6ihtJYsd4Mb0kuC6LV5ramxL6IGPoiDjNyCGeUvY
	 JHgw5x944mB7x1gFGNiKoOQD8DGtHjkBBsmcddG81Xq4zy/i64hqR2sbdV9l3xPepo
	 akihVzLEFSg9RI42A51avSjPgzqQ0gkHkStzbUQc=
X-QQ-mid: zesmtpip4t1794537896t28d3ce76
X-QQ-Originating-IP: 8bNVuMHbsAAJOnkojDgQ/gdWwQl9+fUJephuDPM7+yg=
Received: from workstation-Precision-7920-Towe ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 13 Nov 2026 10:44:54 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 2829769366848978719
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
Subject: [PATCH bpf v2 1/2] bpf: make css iterator stay drained after NULL
Date: Fri, 13 Nov 2026 10:44:52 +0800
Message-Id: <20261113024453.922726-1-k.chen@smail.nju.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261110125110.2935707-1-k.chen@smail.nju.edu.cn>
References: <20261110125110.2935707-1-k.chen@smail.nju.edu.cn>
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
X-QQ-XMAILINFO: MGkdl44gKMhXGT0WLYifunCVXSvlcdhrIi3RyFw/lFbSGNC4nwydAJdR
	wTHg+NQ/FP7WvMgKwpglxwOd22ovoirZvlj+uQvkodxGJkmuDEd81abqE45Xntrg5fW/oLp
	M3EXMBhqMmelRzUXReuBAIiT2N1z0KAbtTp/yPp8k5ITIRFJFwIClSctu804Ob33VjCDvIJ
	Yh08iBvzbaYG4aLTkh0D7T30pR/aCOK6Kq6qNmzsEL4ijP9Ug/OnW6REdiIvIiwK7oMN+h2
	aOdSIjz1AN9xL5+1YrT2P4DWgnvJwifwAKwztalUyNkShDxZwWVsCDYVKWDpizCSKb/JuNj
	JOd42D/l0f58vhTKPurlUPXDpjAkSmQpxveMpC+rznUcmNNd+h6scYBdGppoIiguDML54hB
	CCLezI9EfxPb4XL5kfQmNcVHF5IruQgtpEq0OrHaE9jkv6v7AnZIaoUlireM2TxXtF2x1Pa
	9wWPpyCasaYljOOKO7NL/+n1qYOPyrVfWMCwgjD4S3CNFSeMeJN0iA7cUyDxamcjGsJtYy5
	Y7Hpp5uFWNra54OUUbOEYyNq+U+rT1596yT+b0Z66nqeuSEu9Al5B0GhVEQlcWQ3XXn86Hl
	u3C3o+no6gZPrEQ7Erco8jyLb1zYPjm9maogU2K6cWzjTV+a/hTuXZECBrPZ+iaQt2JLypm
	dOB+HewnlKBtKfbjukAn5P6c96NlC38AfPo3nQI9Nc38d1Pd901gZyMNYMDEGoLaNh68GON
	Ful6ZCQq1udWkZbLBAdqG5qEjk1ZSlZYICTp/+refqz6pnf0s9g9M8lyvwuz2uuJwf9CGSG
	HUWeGRbGwRLmb3vmdQTsWCTfWxpE/o7cqw/L4vXxcCewzy9vb6rsmYfSvOg/O/RvDLxcx6I
	I2mFQgHnIrO/i5AX0KBwcUtUsBF99nU16AZOXFn4SSiEenDUEbKSpxWJgKDlks1oiBhOVuX
	Qv+fJ5xEvhTKcXd/O1oDWpqX/JEqGEPPsz8GjB++ORe7V0yEdxV8w/UBQfY7LrlYJAcVZfh
	olsrInh5akHLrQrIlq
X-QQ-XMRINFO: NI4Ajvh11aEjEMj13RCX7UuhPEoou2bs1g==
X-QQ-RECHKSPAM: 0

bpf_iter_css_next() leaves kit->pos NULL at the end of the walk, but
kit->start still points at the starting css.  css_next_descendant_pre(),
css_next_descendant_post(), css_next_child() and the ancestors walk all
treat a NULL position as "start from @start", so a next() call after
exhaustion returns elements again.

The verifier relies on the iterator contract that once next() returns
NULL it keeps returning NULL: process_iter_next_call() marks the
iterator DRAINED and treats later next() results as the constant zero.
A restarted css iteration therefore hands the BPF program a kernel
pointer while the verifier believes R0 == 0.

Clear kit->start when the position becomes NULL.  bpf_iter_css_destroy()
is a no-op, so no cleanup depends on @start after exhaustion.

Fixes: 7251d0905e75 ("bpf: Introduce css open-coded iterator kfuncs")
Signed-off-by: Kang Chen <k.chen@smail.nju.edu.cn>
---
v2:
- Shorten the code comment; move the rationale to the commit message.

 kernel/bpf/cgroup_iter.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/bpf/cgroup_iter.c b/kernel/bpf/cgroup_iter.c
index fd51fe3d92cc..9e466ef2c433 100644
--- a/kernel/bpf/cgroup_iter.c
+++ b/kernel/bpf/cgroup_iter.c
@@ -365,6 +365,10 @@ __bpf_kfunc struct cgroup_subsys_state *bpf_iter_css_next(struct bpf_iter_css *i
 		kit->pos = kit->pos ? kit->pos->parent : kit->start;
 	}
 
+	/* Once NULL is returned, next() has to keep returning NULL. */
+	if (!kit->pos)
+		kit->start = NULL;
+
 	return kit->pos;
 }
 
-- 
2.34.1

