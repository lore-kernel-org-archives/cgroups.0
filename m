From: Ulrich Drepper <drepper@gmail.com>
Subject: cpuset cleanup race
Date: Tue, 26 Apr 2016 09:01:26 -0400
Message-ID: <CAOPLpQfp9fwYyjv+9f8N9sikL7-+gPg7oq_CsTaRPvowPpXkyg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:from:date:message-id:subject:to;
        bh=qb7+OhnwA7GvP6AzV+o2030Ewiwp14adhgaolv19lFk=;
        b=FSKqbUu9f/E5ttqjriarKzg+oAXScMZAC92f/A/dqawooUxmp/utNzbq0q8YJvQPS6
         CzuGVB+vpSJ07FISZnhI1oBmLMWqN1bxxSltADx1Et/dlmGqbQja6hwkh0tcIYwpB0w4
         O5Z0kDwGwv4UbtbzWRnVn+h32ojqhm0woOqBKdSBIbsK5Jk70vyvnX3fkfCore7flu4m
         ASUklhSaNWaTHCJARyLhuiogDG1WRjRmuDmMklIzGthChnI+/zmiFn/aaEe4mXly68qd
         21x/nIBvYwINj4Ls1wJmsnLqY0og6IKSM7a54WNiEUhDRRqcdTdZZtTv9CSr4XJdlaCl
         fdmw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

I came across a problem with code which uses a cpuset CG and tries to
be responsible and clean up after itself.  The code attached at the
bottom illustrates the problem.  It's only long because it has no
dependencies aside from the basic runtime and should work on all
machines.  You need to run it with privileges high enough to create a
CG.

The code is really simple:
- a (new) CG in cpuset is created
- one of the cores of the root cpuset is selected
- the thread (and therefore entire process) is switched to the cpuset
- a thread is created which does nothing but terminate immediately
- the parent waits for the thread
- then the parent removes itself from the cpuset
- finally the parent tries to remove the created cpuset

The last part is where things go wrong.  Usually* the rmdir() call
made to remove the cpuset fails because the cpuset is still busy.  The
program prints the members of the cpuset CG: it's the child thread.

* I wrote "usually" because slowing down the parent code will help.
I.e., there is a race.  Successful slowdowns I found:
- compile with -fsanitize=address (seems already enough)
- very short wait, e.g., 1ns (you can see this by starting the program
with the parameter "wait")

You might want to compile the code with optimization.  It is a race, after all.


The pthread_join() call made by the parent won't return until the
kernel signals through the futex set up at clone() time that the
thread has terminated.  From the perspective of the userlevel code the
thread is gone.  But not all bookkeeping related to the terminated
thread seems to has been finished, it seems.


I didn't look at the code but I can imagine that the futex
notification happens as soon as all observable aspects of the thread
are gone.  This is of course good to not delay the waiter.  Hopefully
the cgroup bookkeeping can also be moved before the notification.


I tested it with a recent kernel (4.5.0-0.rc7) but I doubt it's a recent issue.


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#include <error.h>
#include <errno.h>
#include <mntent.h>
#include <pthread.h>
#include <sched.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/stat.h>

static void *tf(void *p)
{
  return NULL;
}

int main(int argc, char *argv[])
{
  const char *csname = argc == 1 ? "test" : argv[1];

  struct mntent *me;
  FILE *fp = setmntent(_PATH_MOUNTED, "r");
  if (fp == NULL)
    error(1, errno, "cannot read mounted filesystem information");
  while ((me = getmntent(fp)) != NULL) {
    if (strcmp(me->mnt_type, "cgroup") == 0
&& hasmntopt(me, "cpuset") != NULL)
      break;
  }
  if (me == NULL)
    error(1, 0, "cpuset filesystem not mounted");
  endmntent(fp);

  char *cshier = NULL;
  asprintf(&cshier, "%s/%s", me->mnt_dir, csname);

  if (mkdir(cshier, 0777) == 0)
    printf("new cpuset control group: %s\n", cshier);
  else if (errno != EEXIST)
    error(1, errno, "cannot create cpuset group %s", cshier);

  char *csrootmems;
  asprintf(&csrootmems, "%s/cpuset.mems", me->mnt_dir);
  fp = fopen(csrootmems, "r");
  if (fp == NULL)
    error(1, errno, "cannot read /cpuset.mems");
  char *val = NULL;
  size_t vallen = 0;
  ssize_t n = getline(&val, &vallen, fp);
  fclose(fp);
  free(csrootmems);

  char *testmems;
  asprintf(&testmems, "%s/cpuset.mems", cshier);
  fp = fopen(testmems, "w");
  if (fp == NULL)
    error(1, errno, "cannot read /%s/cpuset.mems", csname);
  fwrite(val, n, 1, fp);
  fclose(fp);
  free(testmems);
  free(val);

  cpu_set_t cs;
  int first = 0;
  sched_getaffinity(0, sizeof(cs), &cs);
  while (! CPU_ISSET(first, &cs))
    ++first;

  char *testcpus;
  asprintf(&testcpus, "%s/cpuset.cpus", cshier);
  fp = fopen(testcpus, "w");
  if (fp == NULL)
    error(1, errno, "cannot write /%s/cpuset.cpus", csname);
  fprintf(fp, "%d", first);
  fclose(fp);
  free(testcpus);

  char *testtasks;
  asprintf(&testtasks, "%s/tasks", cshier);
  fp = fopen(testtasks, "w");
  if (fp == NULL)
    error(1, errno, "cannot write /%s/tasks", csname);
  fprintf(fp, "%d", (int) getpid());
  fclose(fp);

  pthread_t th;
  pthread_create(&th, NULL, tf, NULL);

  pthread_join(th, NULL);

  char *roottasks;
  asprintf(&roottasks, "%s/tasks", me->mnt_dir);
  fp = fopen(roottasks, "w");
  if (fp == NULL)
    error(1, errno, "cannot write /tasks");
  fprintf(fp, "%d", (int) getpid());
  fclose(fp);
  free(roottasks);

  if (strcmp(csname, "wait") == 0) {
    struct timespec s = { 0, 1 };
    nanosleep(&s, NULL);
  }

  if (rmdir(cshier) != 0) {
    printf("PID = %ld\nremaining = ", (long) getpid());
    fp = fopen(testtasks, "r");
    char *line = NULL;
    size_t linelen = 0;
    while ((n = getline(&line, &linelen, fp)) > 0)
      fputs(line, stdout);
    fclose(fp);
    free(line);
    error(1, errno, "couldn't remove cpuset %s", cshier);
  }

  free(cshier);
  free(testtasks);

  return 0;
}
