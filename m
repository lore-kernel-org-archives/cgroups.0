From: Christian Brauner <brauner@kernel.org>
Subject: Re: [RFC v3 8/8] selftests: Add binder cgroup gpu memory transfer
 test
Date: Tue, 22 Mar 2022 17:07:09 +0100
Message-ID: <20220322160709.rcbjgqdoar7lvbox@wittgenstein>
References: <20220309165222.2843651-1-tjmercier@google.com>
 <20220309165222.2843651-9-tjmercier@google.com>
 <CAHRSSEwN4Xuo2vLt8d2QfJbNOK21VB7_NjjbO_XGDz6pYUaXZg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647965240;
        bh=uSOOq0K0AgKLPEeuKOwHFh4OYgLE2Hvt3voMGhHzT6o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fQPHI71f0BUCbQYIhPaRBwike/7mbu7HfbqKAyTZyeXxvTFSZBW8OJHw75FyNjjct
         TkJ06nuufpzYFl30PfmHHBsdFoAVO/Rx0Py/EjuoAKDdpB/pe2RWuS3m6aOIijxKqc
         4QUbiO92sHlJvwFEXOPCHmImzlFcOAhg54Q+11qL1v3uqtjpAMaTzXM5VBvwNrUQaM
         0pDSwIOEuTE6bHlxoGYzBa9s329CV9bgmt8q09zcbRbyvOe2RQxTg2mokYrSjoByFw
         q9ZWxV41RiPsyAX4zQlvXxD0pIV62dPOK62WraDz62dbu/RjKCEGPO0AZga3dK4b2/
         RdPvbVQNl8fyQ==
Content-Disposition: inline
In-Reply-To: <CAHRSSEwN4Xuo2vLt8d2QfJbNOK21VB7_NjjbO_XGDz6pYUaXZg@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Todd Kjos <tkjos@google.com>
Cc: "T.J. Mercier" <tjmercier@google.com>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>, Jonathan Corbet <corbet@lwn.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>, Todd Kjos <tkjos@android.com>, Martijn Coenen <maco@android.com>, Joel Fernandes <joel@joelfernandes.org>, Hridya Valsaraju <hridya@google.com>, Suren Baghdasaryan <surenb@google.com>, Sumit Semwal <sumit.semwal@linaro.org>, Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, Benjamin Gaignard <benjamin.gaignard@linaro.org>, Liam Mark <lmark@codeaurora.org>, Laura

On Mon, Mar 14, 2022 at 05:43:40PM -0700, Todd Kjos wrote:
> On Wed, Mar 9, 2022 at 8:53 AM T.J. Mercier <tjmercier@google.com> wrote:
> >
> > This test verifies that the cgroup GPU memory charge is transferred
> > correctly when a dmabuf is passed between processes in two different
> > cgroups and the sender specifies BINDER_BUFFER_FLAG_SENDER_NO_NEED in the
> > binder transaction data containing the dmabuf file descriptor.
> >
> > Signed-off-by: T.J. Mercier <tjmercier@google.com>
> 
> Reviewed-by: Todd Kjos <tkjos@google.com>
> for the binder driver interactions. Need Christian to take a look at
> the binderfs interactions.

Sorry, just saw this now. I'll take a look tomorrow!
