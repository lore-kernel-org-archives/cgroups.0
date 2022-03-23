From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [RFC v3 1/8] gpu: rfc: Proposal for a GPU cgroup controller
Date: Wed, 23 Mar 2022 11:40:20 +0100
Message-ID: <20220323104020.GI8477@blackbody.suse.cz>
References: <20220309165222.2843651-1-tjmercier@google.com>
 <20220309165222.2843651-2-tjmercier@google.com>
 <20220321173726.GA9640@blackbody.suse.cz>
 <CABdmKX10jqubJr49JENaHpFnqHV88+Fb7iNZNH4T1Cy7n9y=ag@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1648032022; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v5NU/C6p8WEkJ19dl/vKk9SKF9BYMvL6KkJEgBFkRyA=;
        b=RLnV6fiKONXomeCaf7Ul3bMdB8J9ZnoYiQHMukkB3srT4RUf8bFcSLnKzUf+zJWROTJSUe
        Pl2lZGRWXDyr4H6snqXhYysgPcYpop4hSOcwif0tfFhCS180ZIq1pEcabOz0mDgCEyq4gS
        buDZQLypgb5oPEw7PaQ3SKEf0whZcJw=
Content-Disposition: inline
In-Reply-To: <CABdmKX10jqubJr49JENaHpFnqHV88+Fb7iNZNH4T1Cy7n9y=ag@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: "T.J. Mercier" <tjmercier@google.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>, Jonathan Corbet <corbet@lwn.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>, Todd Kjos <tkjos@android.com>, Martijn Coenen <maco@android.com>, Joel Fernandes <joel@joelfernandes.org>, Christian Brauner <brauner@kernel.org>, Hridya Valsaraju <hridya@google.com>, Suren Baghdasaryan <surenb@google.com>, Sumit Semwal <sumit.semwal@linaro.org>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, Benjamin Gaignard <benjamin.gaignard@linaro.org>, Liam Mark <lmark@codeaurora.org>, Laur

On Tue, Mar 22, 2022 at 08:41:55AM -0700, "T.J. Mercier" <tjmercier@google.=
com> wrote:
> So "total" is used twice here in two different contexts.
> The first one is the global "GPU" cgroup context. As in any buffer
> that any exporter claims is a GPU buffer, regardless of where/how it
> is allocated. So this refers to the sum of all gpu buffers of any
> type/source. An exporter contributes to this total by registering a
> corresponding gpucg_device and making charges against that device when
> it exports.
> The second one is in a per device context. This allows us to make a
> distinction between different types of GPU memory based on who
> exported the buffer. A single process can make use of several
> different types of dma buffers (for example cached and uncached
> versions of the same type of memory), and it would be useful to have
> different limits for each. These are distinguished by the device name
> string chosen when the gpucg_device is first registered.

So is this understanding correct?

(if there was an analogous line in gpu.memory.current to gpu.memory.max)
	$ cat gpu.memory.current
	total T
	dev1  d1
	...
	devN  dn

T =3D =CE=A3 di + RAM_backed_buffers

and that some of RAM_backed_buffers may be accounted also in
memory.current (case by case, depending on allocator).

Thanks,
Michal

