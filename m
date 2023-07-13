From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH 0/2] eventfd: simplify signal helpers
Date: Thu, 13 Jul 2023 12:05:36 +0200
Message-ID: <20230713-vfs-eventfd-signal-v1-0-7fda6c5d212b@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1689242764;
	bh=uxBF/65cfGgFc9NUZsYBWMo4c7yjkoqCGF6QeEUJdAY=;
	h=From:Subject:Date:To:Cc:From;
	b=fMIucUY7GArhLgcLDCFIQxCyAzXRgRPE8TkbNnY5GyU1HBPhbd5464W8Yg6jjQ1lL
	 m6CWFlXeaqd10iV8ptWkOllE56aJPowyXSs5WiPty1Qsblb5rDh7+XYZZkXkukuQUD
	 2oiaMlw7C0sww3ot9gyUkCaU1j297MtNOoU25HevXc+ptbrPhHq2Zk21bLHu2o2olV
	 KM6Bl/kUQtYvAIUPH+MSd/KGQP+HX58eb57Amnb444A4mU/RQ41PTUTV2bTgUUDM37
	 0Ncnb1LvDeYFhV3bcDM22YynZx1G+N6CQHl4PYcq4tdmwsqnstpRPCpNQMucQad6SH
	 v0+dq9gbDJkNg==
X-Developer-Signature: v=1; a=openpgp-sha256; l=276; i=brauner@kernel.org;
 h=from:subject:message-id; bh=uxBF/65cfGgFc9NUZsYBWMo4c7yjkoqCGF6QeEUJdAY=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMaSsP1PLoVi0NYRvYnj1752/FbjTRLb2F5/eK1jjLMP8OeoE
 g8DNjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIlwrGT4n2l3WEWjd0VXqt6ih11Ns1
 YfjrROvjc3V73IYWbr0apscUaGq6+my1lGuQtz2O564OagKGE5qVEnsLx/a9H1rIRnpwXZAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Sender: owner-linux-aio@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-fsdevel@vger.kernel.org
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>, Oded Gabbay <ogabbay@kernel.org>, Wu Hao <hao.wu@intel.com>, Tom Rix <trix@redhat.com>, Moritz Fischer <mdf@kernel.org>, Xu Yilun <yilun.xu@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, Zhi Wang <zhi.a.wang@intel.com>, Jani Nikula <jani.nikula@linux.intel.com>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>, David Airlie <airlied@gmail.com>, Daniel Vetter <daniel@ffwll.ch>, Leon Romanovsky <leon@kernel.org>, Jason

Hey everyone,

This simplifies the eventfd_signal() and eventfd_signal_mask() helpers
by removing the count argument which is effectively unused.

---



---
base-commit: 6be357f00aad4189130147fdc6f568cf776a4909
change-id: 20230713-vfs-eventfd-signal-0b0d167ad6ec


--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
