From: Daniel Dao <dqminh-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>
Subject: Re: [PATCH] io_uring/io-wq: stop setting PF_NO_SETAFFINITY on io-wq workers
Date: Tue, 14 Mar 2023 10:07:40 +0000
Message-ID: <CA+wXwBRGzfZB9tjKy5C2_pW1Z4yH2gNGxx79Fk-p3UsOWKGdqA@mail.gmail.com>
References: <0f0e791b-8eb8-fbb2-ea94-837645037fae@kernel.dk>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1678788471;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ok3cioucmJfuqToGWB847OqBj7qCzxyQQ0EoG5bYZE4=;
        b=R37fmEuO0gMfIx7lcApi2XBVNccL81RrFPvxi9zi6GkpXFewb3tSL2AJQCIlrc7PWa
         Vbh6TX70ujrEhyBXTGjbJKDwjK2t/cpGPCyKWORm9vs2Y+t5HYGzsIJiWiUWjjXHah5i
         T4ZotFNP5ZbdIju97rz4G3JZlCrQJG9hHV87s=
In-Reply-To: <0f0e791b-8eb8-fbb2-ea94-837645037fae-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: io-uring <io-uring-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Mar 8, 2023 at 2:27=E2=80=AFPM Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org> wrote:
>
> Every now and then reports come in that are puzzled on why changing
> affinity on the io-wq workers fails with EINVAL. This happens because the=
y
> set PF_NO_SETAFFINITY as part of their creation, as io-wq organizes
> workers into groups based on what CPU they are running on.
>
> However, this is purely an optimization and not a functional requirement.
> We can allow setting affinity, and just lazily update our worker to wqe
> mappings. If a given io-wq thread times out, it normally exits if there's
> no more work to do. The exception is if it's the last worker available.
> For the timeout case, check the affinity of the worker against group mask
> and exit even if it's the last worker. New workers should be created with
> the right mask and in the right location.

The patch resolved the bug around enabling cpuset for subtree_control for m=
e.
However, it also doesn't prevent user from setting cpuset value that
is incompatible
with iou threads. For example, on a 2-numa 4-cpu node, new iou-wrks are bou=
nd to
2-3 while we can set cpuset.cpus to 1-2 successfully. The end result
is a mix of cpu
distribution such as:

  pid 533's current affinity list: 1,2 # process
  pid 720's current affinity list: 1,2 # iou-wrk-533
  pid 5236's current affinity list: 2,3 # iou-wrk-533, running outside of c=
puset


IMO this violated the principle of cpuset and can be confusing for end user=
s.
I think I prefer Waiman's suggestion of allowing an implicit move to cpuset
when enabling cpuset with subtree_control but not explicit moves such as wh=
en
setting cpuset.cpus or writing the pids into cgroup.procs. It's easier to r=
eason
about and make the failure mode more explicit.

What do you think ?

Cheers,
Daniel.
