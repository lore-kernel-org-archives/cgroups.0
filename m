From: "T.J. Mercier" <tjmercier@google.com>
Subject: [RFC v3 7/8] binder: use __kernel_pid_t and __kernel_uid_t for userspace
Date: Wed,  9 Mar 2022 16:52:17 +0000
Message-ID: <20220309165222.2843651-8-tjmercier@google.com>
References: <20220309165222.2843651-1-tjmercier@google.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=a5Dt/ckgrAR/j0DHD5MablupC6tRY3n4B+kc2OBEq1E=;
        b=lf6qdnlnShM+NyA+sRumM9hivTRIGcCncGZbgQNzurEcC0PelK7f0Thi+M3ueh/60u
         crlhMuUH1ipr0mpuDqyE8aJ84VySIaff1FD+fE9773Bt+fv449Jm3nP3wPIlVA+Qfzav
         0k2WlYeS8LRPkeGvJS/ckcrKMSgPM5JtRDzCNqenqST8iJomE7l5mxPW2JqytjG7tKEz
         E11F13r1PzT40iKei9VjsWcsCTlAVdI2efPX0/uTfWtH4OCy9bcb/rt71jwCVzpmmrbw
         9TYlUoBsQKAMkXQRru4/JO9WydZpoUuui7gHXDFAFHPvAuocMffpVfEKhnWZZaGcVMZ7
         KGKw==
In-Reply-To: <20220309165222.2843651-1-tjmercier@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>, Jonathan Corbet <corbet@lwn.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>, Todd Kjos <tkjos@android.com>, Martijn Coenen <maco@android.com>, Joel Fernandes <joel@joelfernandes.org>, Christian Brauner <brauner@kernel.org>, Hridya Valsaraju <hridya@google.com>, Suren Baghdasaryan <surenb@google.com>, Sumit Semwal <sumit.semwal@linaro.org>, =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>, Benjamin Gaignard <benjamin.gaignard@linaro.org>, Liam Mark <lmark@codeaurora.org>
Cc: kaleshsingh@google.com, Kenny.Ho@amd.com, "T.J. Mercier" <tjmercier@google.com>, dri-devel@lists.freedesktop.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org, cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org

The kernel interface should use types that the kernel defines instead of
pid_t and uid_t, whose definiton is owned by libc. This fixes the header
so that it can be included without first including sys/types.h.

Signed-off-by: T.J. Mercier <tjmercier@google.com>
---
 include/uapi/linux/android/binder.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/android/binder.h b/include/uapi/linux/android/binder.h
index 169fd5069a1a..aa28454dbca3 100644
--- a/include/uapi/linux/android/binder.h
+++ b/include/uapi/linux/android/binder.h
@@ -289,8 +289,8 @@ struct binder_transaction_data {
 
 	/* General information about the transaction. */
 	__u32	        flags;
-	pid_t		sender_pid;
-	uid_t		sender_euid;
+	__kernel_pid_t	sender_pid;
+	__kernel_uid_t	sender_euid;
 	binder_size_t	data_size;	/* number of bytes of data */
 	binder_size_t	offsets_size;	/* number of bytes of offsets */
 
-- 
2.35.1.616.g0bdcbb4464-goog

